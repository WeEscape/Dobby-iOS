//
//  Date+.swift
//  Dobby
//
//  Created by yongmin lee on 10/30/22.
//

import Foundation

extension Date {
    func toStringWithoutTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
}
