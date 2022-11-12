//
//  Date+.swift
//  Dobby
//
//  Created by yongmin lee on 10/30/22.
//

import Foundation

extension Date {
    func toStringWithoutTime(dateFormat: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
}
