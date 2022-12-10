//
//  WeeklyChoreViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 12/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class WeeklyChoreViewModel {
    
    // MARK: property
    var disposBag: DisposeBag = .init()
    let loadingPublish: PublishRelay<Bool> = .init()
    let pageVCDataSourceBehavior: BehaviorRelay<[UIViewController]> = .init(value: [])
    let dateListBehavior: BehaviorRelay<[Date]> = .init(value: [])
    let selectedDateBehavior: BehaviorRelay<[Date]> = .init(value: [
        Date().getLastWeek(),
        Date()
    ])
    let choreCardVCFactory: (Date) -> UIViewController
    
    // MARK: init
    init(
        choreCardVCFactory: @escaping(Date) -> UIViewController
    ) {
        self.choreCardVCFactory = choreCardVCFactory
    }
    
    // MARK: methods
    func updateSelectedDate(_ date: Date) {
        var selectedDates = selectedDateBehavior.value
        selectedDates.removeFirst()
        selectedDates.append(date)
        selectedDateBehavior.accept(selectedDates)
    }
    
    func didUpdatedSelectedDate() {
        guard let currentDate = selectedDateBehavior.value.last else {return}
        let dateList: [Date] = [
            currentDate.getLastWeek(),
            currentDate,
            currentDate.getNextWeek()
        ]
        dateListBehavior.accept(dateList)
        
        let pageVCDataSource = createPageVCDataSource(with: dateList)
        pageVCDataSourceBehavior.accept(pageVCDataSource)
    }
    
    func createPageVCDataSource(with dateList: [Date]) -> [UIViewController] {
        var ret = [UIViewController]()
        dateList.forEach { date in
            let vc = choreCardVCFactory(date)
            ret += [vc]
        }
        return ret
    }
}
