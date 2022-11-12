//
//  DailyChoreViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 11/12/22.
//

import Foundation
import RxSwift
import RxCocoa

class DailyChoreViewModel: BaseViewModel {
    
    let dateStringBehavior: BehaviorRelay<[DateStrListSection]> = .init(value: [])
    let selectedDatePublish: PublishRelay<Int> = .init()
    
    func viewDidAppear() {
        let today = Date()
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month, .day], from: today)
        component.day! -= 7
        
        var dateStrList: [String] = .init()
        for _ in 0...15 {
            if let dateStr = calendar.date(from: component)?.toStringWithoutTime() {
                dateStrList.append(dateStr)
            }
            component.day! += 1
        }
        if dateStringBehavior.value.first?.items != dateStrList {
            dateStringBehavior.accept([.init(dates: dateStrList)])
            self.selectedDatePublish.accept(7)
        }
    }
    
    func didTapCell(_ index: Int) {
        print("Debug : DailyChoreViewModel didTapCell -> \(index)")
    }
}
