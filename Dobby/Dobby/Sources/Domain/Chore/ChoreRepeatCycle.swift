//
//  ChoreRepeatCycle.swift
//  Dobby
//
//  Created by yongmin lee on 11/6/22.
//

import Foundation

enum ChoreRepeatCycle: String, CaseIterable {
    case off = "off"
    case everyday = "1D"
    case everyWeek = "1W"
    case everyMonth = "1M"
}

extension ChoreRepeatCycle: CustomStringConvertible {
    var description: String {
        switch self {
        case .off:
            return "반복안함"
        case .everyday:
            return "매일"
        case .everyWeek:
            return "매주"
        case .everyMonth:
            return "매달"
        }
    }
}
