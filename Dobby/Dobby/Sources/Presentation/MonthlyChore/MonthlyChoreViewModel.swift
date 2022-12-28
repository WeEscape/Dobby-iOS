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
    let selectedDate: BehaviorRelay<Date> = .init(value: Date())
    
    // MARK: init
    init() {
        
    }
    
    // MARK: methods
    func fetchMonthlyChoreList() {

        BeaverLog.verbose(" fetchMonthlyChoreList ")
    }
    
    func didSelectDate(_ date: Date) {
        self.selectedDate.accept(date)
    }
    
    func checkEventExist(for date: Date) -> Bool {
        if date.toStringWithoutTime() == "2022-12-25" {
            return true
        }
        return false
    }
    
}
