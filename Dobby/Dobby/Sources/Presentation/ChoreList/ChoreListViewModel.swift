//
//  ChoreListViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 11/13/22.
//

import Foundation
import RxSwift

class ChoreListViewModel: BaseViewModel {
    
    // MARK: property
    let dateList: [Date]
    
    // MARK: initialize
    init(dateList: [Date]) {
        self.dateList = dateList
    }
    
    func viewDidAppear() {
        
    }
    
}
