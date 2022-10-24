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
    let selectedTab = BehaviorRelay<MainTab>(value: .dailyChore)
    let pushAddChoreTab = PublishRelay<Void>()
    
    func didSelect(selectIdx: Int) {
        guard let selectedTab = MainTab(rawValue: selectIdx) else { return }
        if selectedTab == .addChore {
            let lastIndex = self.selectedTab.value
            self.selectedTab.accept(lastIndex)
            pushAddChoreTab.accept(())
        } else {
            self.selectedTab.accept(selectedTab)
        }
    }
}
