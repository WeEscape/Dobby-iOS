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
    let choreListBehavior: BehaviorRelay<[[Chore]]> = .init(value: [])
    let messagePublish: PublishRelay<String>  = .init()
    
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
                    guard let userId = myinfo.userId else {return .error(CustomError.init())}
                    return self.groupUseCase.getGroupInfo(id: userId)
                } else {
                    self.memberListBehavior.accept([myinfo])
//                    self.loadingPublish.accept(false)
                    return .empty()
                }
            }
            .subscribe(onNext: { [weak self] group in
                guard let members = group.memberList else {return}
                self?.memberListBehavior.accept(members)
//                self?.loadingPublish.accept(false)
            }, onError: { [weak self] _ in
                self?.loadingPublish.accept(false)
            }).disposed(by: self.disposBag)
    }
    
    func getChoreList(of members: [User]) {
        var observableList: [Observable<[Chore]>] = .init()
        if let groupId = members.last?.groupList?.last?.groupId {
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
                    self?.choreListBehavior.accept(choreList)
                    self?.loadingPublish.accept(false)
                }, onError: { [weak self] _ in
                    self?.choreListBehavior.accept([])
                    self?.loadingPublish.accept(false)
                }).disposed(by: self.disposBag)
        } else {
            self.choreListBehavior.accept([])
            self.messagePublish.accept("참여중인 그룹이 없습니다.")
            self.loadingPublish.accept(false)
        }
    }
    
    func toggleChoreIsEnd(_ chore: Chore, userId: String, isEnd: Bool) {
        self.choreUseCase.finishChore(chore: chore, userId: userId, isEnd: isEnd)
            .subscribe(onNext: { [weak self] _ in
                guard let memberlist = self?.memberListBehavior.value else {return}
                self?.memberListBehavior.accept(memberlist)
            }).disposed(by: self.disposBag)
    }
}