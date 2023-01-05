//
//  MonthlyChoreViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 12/28/22.
//

import Foundation
import RxSwift
import RxCocoa

class MonthlyChoreViewModel {
    
    // MARK: property
    var disposBag: DisposeBag = .init()
    let loadingPublish: PublishRelay<Bool> = .init()
    let calendarReloadPublish: PublishRelay<Void> = .init()
    let selectedDateBehavior: BehaviorRelay<Date> = .init(value: Date())
    let choreDateListBehavior: BehaviorRelay<[String]> = .init(value: [])
    
    let choreUseCase: ChoreUseCase
    let userUseCase: UserUseCase
    let groupUseCase: GroupUseCase
    
    // MARK: init
    init(
        choreUseCase: ChoreUseCase,
        userUseCase: UserUseCase,
        groupUseCase: GroupUseCase
    ) {
        self.choreUseCase = choreUseCase
        self.userUseCase = userUseCase
        self.groupUseCase = groupUseCase
    }
    
    // MARK: methods
    func fetchMonthlyChoreList(_ date: Date) {
        self.userUseCase.getMyInfo()
            .flatMapLatest { [unowned self] myinfo -> Observable<Group> in
                guard let groupId = myinfo.groupList?.last?.groupId
                else {return .error(CustomError(memo: "no group"))}
                return self.groupUseCase.getGroupInfo(id: groupId)
            }
            .flatMapLatest { [unowned self] groupInfo -> Observable<[[Chore]]> in
                guard let groupId = groupInfo.groupId,
                      let members = groupInfo.memberList
                else {return .error(CustomError(memo: "no groupInfo"))}
                var observableList: [Observable<[Chore]>] = .init()
                members.forEach { member in
                    let observable = self.choreUseCase.getChores(
                        userId: member.userId!,
                        groupId: groupId,
                        date: date,
                        periodical: .monthly
                    )
                    observableList.append(observable)
                }
                return Observable.zip(observableList)
            }
            .subscribe(onNext: { [weak self] chores in
                let choreList = chores.flatMap {$0}
                var choreDateList = choreList.map { chore in
                    chore.executeAt
                }
                choreDateList = Array(Set(choreDateList))
                self?.choreDateListBehavior.accept(choreDateList)
                self?.calendarReloadPublish.accept(())
            }, onError: { [weak self] _ in
                self?.choreDateListBehavior.accept([])
                self?.calendarReloadPublish.accept(())
            }).disposed(by: self.disposBag)
    }
    
    func didSelectDate(_ date: Date) {
        self.selectedDateBehavior.accept(date)
    }
    
    func checkEventExist(for date: Date) -> Bool {
        let checkExist = self.choreDateListBehavior.value.filter { choreDate in
            choreDate.contains(date.toStringWithFormat())
        }
        return !checkExist.isEmpty
    }
}
