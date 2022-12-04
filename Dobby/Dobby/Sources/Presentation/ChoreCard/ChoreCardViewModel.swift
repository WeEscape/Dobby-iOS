//
//  ChoreCardViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 11/13/22.
//

import Foundation
import RxSwift
import RxCocoa

class ChoreCardViewModel: BaseViewModel {
    
    // MARK: property
    let isGroupChore: Bool
    let dateList: [Date]
    
    let memberListPublish: PublishRelay<[User]> = .init()
    let choreListBehavior: BehaviorRelay<[[Chore]]> = .init(value: [])
    
    // MARK: initialize
    init(dateList: [Date], isGroupChore: Bool) {
        self.isGroupChore = isGroupChore
        self.dateList = dateList
    }
    
    func getMemberList() {
        self.loadingPublish.accept(true)
        
        if isGroupChore {
            // 내 그룹 멤버 정보
            
        } else {
            // 내정보
            
        }
    }
}
