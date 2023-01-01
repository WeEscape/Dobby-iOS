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
    
    // MARK: init
    init(
        choreUseCase: ChoreUseCase,
        userUseCase: UserUseCase
    ) {
        self.choreUseCase = choreUseCase
        self.userUseCase = userUseCase
    }
    
    // MARK: methods
    func fetchMonthlyChoreList(_ date: Date) {
        self.userUseCase.getMyInfo()
            .flatMapLatest { [unowned self] myinfo -> Observable<[Chore]> in
                guard let userId = myinfo.userId,
                      let groupId = myinfo.groupList?.last?.groupId
                else {return .error(CustomError(memo: "no myinfo"))}
                return self.choreUseCase.getChores(
                    userId: userId,
                    groupId: groupId,
                    date: date,
                    periodical: .monthly
                )
            }
            .subscribe(onNext: { [weak self] choreList in
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
            choreDate.contains(date.toStringWithoutTime())
        }
        return !checkExist.isEmpty
    }
}
