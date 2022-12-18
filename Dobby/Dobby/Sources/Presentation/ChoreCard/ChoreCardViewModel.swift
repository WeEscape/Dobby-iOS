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
    
    let memberListBehavior: BehaviorRelay<[User]> = .init(value: [])
    let choreArrPublish: PublishRelay<[Chore]> = .init()
    let messagePublish: PublishRelay<String>  = .init()
    var myInfo: User?
    var groupId: String?
    
    // MARK: initialize
    init(
        choreCardPeriod: ChorePeriodical,
        dateList: [Date],
        userUseCase: UserUseCase,
        groupUseCase: GroupUseCase,
        choreUseCase: ChoreUseCase
    ) {
        self.choreCardPeriod = choreCardPeriod
        self.dateList = dateList
        self.userUseCase = userUseCase
        self.groupUseCase = groupUseCase
        self.choreUseCase = choreUseCase
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
                self?.choreArrPublish.accept([])
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
                    let choreArr = choreList.flatMap {$0}
                    self?.choreArrPublish.accept(choreArr)
                    self?.loadingPublish.accept(false)
                }, onError: { [weak self] _ in
                    self?.choreArrPublish.accept([])
                    self?.loadingPublish.accept(false)
                }).disposed(by: self.disposBag)
        } else {
            self.choreArrPublish.accept([])
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
}
