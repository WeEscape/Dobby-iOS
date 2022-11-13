//
//  DateListSection.swift
//  Dobby
//
//  Created by yongmin lee on 11/12/22.
//

import Foundation
import RxDataSources

struct DateListSection {
    var dates: [Date]
}

extension DateListSection: SectionModelType, Equatable {
    
    var items: [Date] {
        return self.dates
    }
    
    init(original: DateListSection, items: [Date]) {
        self = original
        self.dates = items
    }
}
