//
//  SelectChoreAttributeViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 10/29/22.
//

import Foundation

protocol SelectChoreAttributeDelegate: AnyObject {
    
}

class SelectChoreAttributeViewModel {
    
    weak var delagate: SelectChoreAttributeDelegate?
    let choreAttribute: ChoreAttribute
    
    init(choreAttribute: ChoreAttribute) {
        self.choreAttribute = choreAttribute
    }
}
