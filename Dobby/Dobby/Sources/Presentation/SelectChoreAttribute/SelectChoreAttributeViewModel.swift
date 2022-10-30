//
//  SelectChoreAttributeViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 10/29/22.
//

import Foundation

protocol SelectChoreAttributeDelegate: AnyObject {
    func didSelectDate(date: Date)
}

class SelectChoreAttributeViewModel {
    
    weak var delagate: SelectChoreAttributeDelegate?
    let choreAttribute: ChoreAttribute
    
    init(choreAttribute: ChoreAttribute) {
        self.choreAttribute = choreAttribute
    }
    
    deinit {
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
    func didSelectDate(_ date: Date) {
        self.delagate?.didSelectDate(date: date)
    }
}
