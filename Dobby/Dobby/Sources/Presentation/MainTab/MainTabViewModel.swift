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
    let selectedTabIndex = BehaviorRelay<Int>(value: 0)
    let pushAddChoreTab = PublishRelay<Void>()
    
    func didSelect(index: Int) {
        guard let newTab = tabItems.value[safe: index] else { return }
        if newTab == .addChore {
            let lastTabIndex = self.selectedTabIndex.value
            self.selectedTabIndex.accept(lastTabIndex)
            pushAddChoreTab.accept(())
        } else {
            self.selectedTabIndex.accept(index)
        }
    }
}
