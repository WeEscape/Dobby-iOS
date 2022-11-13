//
//  DailyChoreViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 11/12/22.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit

class DailyChoreViewModel: BaseViewModel {
    
    // MARK: property
    let dateListSectionBehavior: BehaviorRelay<[DateListSection]> = .init(value: [])
    let selectedDatePublish: PublishRelay<DateComponents> = .init()
    let selectedCellIndexBehavior: BehaviorRelay<[Int]?> = .init(value: nil)
    let pageVCDataSourceBehavior: BehaviorRelay<[UIViewController]> = .init(value: [])
    
    // MARK: methods
    func viewDidAppear() {
        let today = Date()
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month, .day, .weekday], from: today)
        component.day! -= 7
        let dateArrange = 0...14
        var dateList: [Date] = .init()
        for _ in dateArrange {
            if let date = calendar.date(from: component) {
                dateList.append(date)
            }
            component.day! += 1
        }
        if dateListSectionBehavior.value.first?.items != dateList {
            dateListSectionBehavior.accept([.init(dates: dateList)])
            let pageVCDataSource = createPageVCDataSource(with: dateList)
            pageVCDataSourceBehavior.accept(pageVCDataSource)
            let todayDateComponent = calendar.dateComponents(
                [.year, .month, .day, .weekday],
                from: today
            )
            self.selectedDatePublish.accept(todayDateComponent)
            let middle = (dateArrange.count / 2)
            self.emitNewSelectedCellIndex(middle)
        }
    }
    
    func didSelectCell(_ index: Int) {
        guard let selectedDate = dateListSectionBehavior.value.first?.items[safe: index]
        else {return}
        let calendar = Calendar.current
        let component = calendar.dateComponents(
            [.year, .month, .day, .weekday],
            from: selectedDate
        )
        self.selectedDatePublish.accept(component)
        self.emitNewSelectedCellIndex(index)
    }
    
    func createPageVCDataSource(with dateList: [Date]) -> [UIViewController] {
        var ret = [UIViewController]()
        dateList.forEach { date in
            let vc = DailyChoreDetailViewController()
            vc.dateLabel.text = date.toStringWithoutTime()
            ret += [vc]
        }
        return ret
    }
    
    func emitNewSelectedCellIndex(_ newIndex: Int) {
        var selectedCellIndexes = selectedCellIndexBehavior.value ?? [0, 0]
        selectedCellIndexes.removeFirst()
        selectedCellIndexes.append(newIndex)
        selectedCellIndexBehavior.accept(selectedCellIndexes)
    }
    
    func didTapGotoToday() {
        let numberOfCell = dateListSectionBehavior.value.first?.items.count ?? 0
        let middle = (numberOfCell / 2)
        if middle >= 0 {
            let calendar = Calendar.current
            let todayDateComponent = calendar.dateComponents(
                [.year, .month, .day, .weekday],
                from: Date()
            )
            self.selectedDatePublish.accept(todayDateComponent)
            self.emitNewSelectedCellIndex(middle)
        }
    }
}
