//
//  DateListSection.swift
//  Dobby
//
//  Created by yongmin lee on 11/12/22.
//

import Foundation
import RxDataSources

struct DateStrListSection {
    typealias DateString = String
    var dates: [DateString]
}

extension DateStrListSection: SectionModelType, Equatable {
    
    var items: [DateString] {
        return self.dates
    }
    
    init(original: DateStrListSection, items: [DateString]) {
        self = original
        self.dates = items
    }
}
