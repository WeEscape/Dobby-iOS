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
    
    func getNextMonth() -> Date? {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month, .day], from: Date())
        component.month! += 1
        let nextMonth = calendar.date(from: component)
        return nextMonth
    }
    
    func getLastMonth() -> Date? {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month, .day], from: Date())
        component.month! -= 1
        let lastMonth = calendar.date(from: component)
        return lastMonth
    }
    
    func calculateDiffDate(diff: Int) -> Date? {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month, .day], from: self)
        component.day! += diff
        let res = calendar.date(from: component)
        return res
    }
}
