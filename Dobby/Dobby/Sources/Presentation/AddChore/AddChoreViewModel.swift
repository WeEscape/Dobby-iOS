//
//  AddChoreViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import Foundation
import RxSwift
import RxRelay

final class AddChoreViewModel {
    
    var disposeBag: DisposeBag = .init()
    let attributeItems = BehaviorRelay<[ChoreAttribute]>(value: ChoreAttribute.allCases)
    let dateBehavior: BehaviorRelay<Date?> = .init(value: nil)
    let repeatCycleList: [ChoreRepeatCycle] = ChoreRepeatCycle.allCases
    let repeatCycleBehavior: BehaviorRelay<ChoreRepeatCycle?> = .init(value: nil)
    let myinfoBehavior: BehaviorRelay<User?> = .init(value: nil)
    let disableAddChore: PublishRelay<Void> = .init()
    let loadingPublush: PublishRelay<Bool> = .init()
    let saveBtnEnableBehavior: BehaviorRelay<Bool> = .init(value: false)
    let choreUseCase: ChoreUseCase
    let userUseCase: UserUseCase
    
    init(
        choreUseCase: ChoreUseCase,
        userUseCase: UserUseCase
    ) {
        self.choreUseCase = choreUseCase
        self.userUseCase = userUseCase
        BeaverLog.debug("\(String(describing: self)) init")
    }
    
    deinit {
        self.disposeBag = .init()
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
    func didTapAddBtn() {
        print("AddChoreViewModel didTapAddBtn ")
    }
    
    func didSelectDate(date: Date) {
        dateBehavior.accept(date)
    }
    
    func didSelectRepeatCycle(repeatCycle: ChoreRepeatCycle) {
        repeatCycleBehavior.accept(repeatCycle)
    }
    
    func getMyInfo() {
        self.userUseCase.getMyInfo()
            .subscribe(onNext: { [weak self] myinfo in
                self?.myinfoBehavior.accept(myinfo)
                if myinfo.groupIds == nil || myinfo.groupIds!.isEmpty {
                    self?.disableAddChore.accept(())
                }
            }).disposed(by: self.disposeBag)
    }
}
