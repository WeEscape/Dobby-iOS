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
    let choreUseCase: ChoreUseCase
    let dateBehavior: BehaviorRelay<Date?> = .init(value: nil)
    let repeatCycleList: [ChoreRepeatCycle] = ChoreRepeatCycle.allCases
    let repeatCycleBehavior: BehaviorRelay<ChoreRepeatCycle?> = .init(value: nil)
    
    init(
        choreUseCase: ChoreUseCase
    ) {
        self.choreUseCase = choreUseCase
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
}
