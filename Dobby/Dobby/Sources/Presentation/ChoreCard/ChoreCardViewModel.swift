//
//  ChoreCardViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 11/13/22.
//

import Foundation
import RxSwift
import RxCocoa

class ChoreCardViewModel: BaseViewModel {
    
    // MARK: property
    let choreCardPeriod: ChorePeriodical
    let dateList: [Date]
    let userUseCase: UserUseCase
    let groupUseCase: GroupUseCase
    let choreUseCase: ChoreUseCase
    let alarmUseCase: AlarmUseCase
    
    let memberListBehavior: BehaviorRelay<[User]> = .init(value: [])
    let choreArrBehavior: BehaviorRelay<[Chore]> = .init(value: [])
    let messagePublish: PublishRelay<String>  = .init()
    var myInfo: User?
    var groupId: String?
    
    // MARK: initialize
    init(
        choreCardPeriod: ChorePeriodical,
        dateList: [Date],
        userUseCase: UserUseCase,
        groupUseCase: GroupUseCase,
        choreUseCase: ChoreUseCase,
        alarmUseCase: AlarmUseCase
    ) {
        self.choreCardPeriod = choreCardPeriod
        self.dateList = dateList
        self.userUseCase = userUseCase
        self.groupUseCase = groupUseCase
        self.choreUseCase = choreUseCase
        self.alarmUseCase = alarmUseCase
    }
    
    func getMemberList() {
        self.userUseCase.getMyInfo()
            .flatMapLatest { [unowned self] myinfo -> Observable<Group> in
                if choreCardPeriod != .daily {
                    guard let groupId = myinfo.groupList?.last?.groupId
                    else {
                        self.groupId = nil
                        return .error(CustomError.init())
                    }
                    self.groupId = groupId
                    self.myInfo = myinfo
                    return self.groupUseCase.getGroupInfo(id: groupId)
                } else {
                    guard let groupId = myinfo.groupList?.last?.groupId
                    else {
                        self.groupId = nil
                        return .error(CustomError.init())
                    }
                    self.groupId = groupId
                    self.memberListBehavior.accept([myinfo])
                    return .empty()
                }
            }
            .subscribe(onNext: { [weak self] group in
                guard let members = group.memberList else {return}
                self?.memberListBehavior.accept(members)
            }, onError: { [weak self] _ in
                self?.choreArrBehavior.accept([])
                self?.messagePublish.accept("참여중인 그룹이 없습니다.")
                self?.loadingPublish.accept(false)
            }).disposed(by: self.disposBag)
    }
    
    func getChoreList(of members: [User]) {
        var observableList: [Observable<[Chore]>] = .init()
        if let groupId = self.groupId {
            dateList.forEach {  date in
                members.forEach { member in
                    let observable = self.choreUseCase.getChores(
                        userId: member.userId!,
                        groupId: groupId,
                        date: date,
                        periodical: .daily
                    )
                    observableList.append(observable)
                }
            }
            Observable.zip(observableList)
                .subscribe(onNext: { [weak self] choreList in
                    guard let self = self else {return}
                    let choreArr = choreList.flatMap {$0}
                    self.choreArrBehavior.accept(choreArr)
                    self.loadingPublish.accept(false)
                    if self.choreCardPeriod == .weekly {
                        self.updateLocalAlarm()
                    }
                }, onError: { [weak self] _ in
                    self?.choreArrBehavior.accept([])
                    self?.loadingPublish.accept(false)
                }).disposed(by: self.disposBag)
        } else {
            self.choreArrBehavior.accept([])
            self.messagePublish.accept("참여중인 그룹이 없습니다.")
            self.loadingPublish.accept(false)
        }
    }
    
    func refreshChoreList() {
        let memberlist = self.memberListBehavior.value
        self.getChoreList(of: memberlist)
    }
    
    func toggleChoreIsEnd(_ chore: Chore, userId: String, isEnd: Bool) {
        self.choreUseCase.finishChore(chore: chore, userId: userId, isEnd: isEnd)
            .subscribe(onNext: { [weak self] _ in
                self?.refreshChoreList()
            }, onError: { [weak self] _ in
                self?.refreshChoreList()
            }).disposed(by: self.disposBag)
    }
    
    func deleteChore(chore: Chore) {
        self.choreUseCase.deleteChore(chore: chore)
            .subscribe(onNext: { [weak self] _ in
                self?.refreshChoreList()
            }, onError: { [weak self] _ in
                self?.refreshChoreList()
            }).disposed(by: self.disposBag)
    }
    
    func updateLocalAlarm() {
        let alarmInfo = self.alarmUseCase.getAlarmInfo()
        if !alarmInfo.isOn {
            // 알람 off
            self.alarmUseCase.removeAllAlarm()
            return
        }
        // 전체 집안일중에 나의 집안일 필터
        var choreList = choreArrBehavior.value
        choreList = choreList.filter { chore in
            guard let ownerList = chore.ownerList,
                  let myId = self.myInfo?.userId
            else {return false}
            return ownerList.contains(where: { owner in
                owner.userId == myId
            })
        }
        var choreDateList = choreList.map { chore in
            chore.executeAt
        }
        choreDateList = Array(Set(choreDateList))
        // 오늘 또는 내일 집안일이 있는지 체크
        guard let tomorrow = Date().calculateDiffDate(diff: 1)?.toStringWithFormat()
        else {return}
        let tomorrowExist = choreDateList.filter { choreDate in
            choreDate.contains(tomorrow)
        }
        let today = Date().toStringWithFormat()
        let todayExist = choreDateList.filter { choreDate in
            choreDate.contains(today)
        }
        if tomorrowExist.isEmpty, todayExist.isEmpty {
            self.alarmUseCase.removeAllAlarm()
            return
        }
        if !tomorrowExist.isEmpty {
            // 내일 나의 집안일이 있는지 체크
            self.alarmUseCase.registAlarm(at: alarmInfo.time, isTodayAlarm: false)
        }
        if !todayExist.isEmpty {
            // 오늘 나의 집안일이 있는지 체크
            self.alarmUseCase.registAlarm(at: alarmInfo.time, isTodayAlarm: true)
        }
    }
}
