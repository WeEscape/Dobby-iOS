//
//  ChoreListViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 11/13/22.
//

import Foundation
import RxSwift
import RxCocoa

class ChoreListViewModel: BaseViewModel {
    
    // MARK: property
    let isGroupChore: Bool
    let dateList: [Date]
    let choreListPerDatBehavior: BehaviorRelay<[[Chore]]> = .init(value: [])
//    var memberList: [User]?
    
    // MARK: initialize
    init(dateList: [Date], isGroupChore: Bool) {
        self.isGroupChore = isGroupChore
        self.dateList = dateList
    }
    
    func viewDidAppear() {
        // fetch chore list with [date]. [User]
    }
    
}
