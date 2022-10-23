//
//  MainTabViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 10/17/22.
//

import Foundation
import RxRelay
import RxSwift

class MainTabViewModel {
    let tabItems = BehaviorRelay<[MainTab]>(value: MainTab.allCases)
    let selectedTab = BehaviorRelay<MainTab>(value: .dailyTask)
    let pushAddTaskTab = PublishRelay<Void>()
    
    func didSelect(selectIdx: Int) {
        guard let selectedTab = MainTab(rawValue: selectIdx) else { return }
        if selectedTab == .addTask {
            let lastIndex = self.selectedTab.value
            self.selectedTab.accept(lastIndex)
            pushAddTaskTab.accept(())
        } else {
            self.selectedTab.accept(selectedTab)
        }
    }
}
