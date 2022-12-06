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
    
    func getWeekday() -> String? {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month, .day, .weekday], from: self)
        var ret: String?
        if let weekday = component.weekday {
            if weekday == 1 { ret = "SUN" }
            else if weekday == 2 { ret = "MON" }
            else if weekday == 3 { ret = "TUE" }
            else if weekday == 4 { ret = "WED" }
            else if weekday == 5 { ret = "TUR" }
            else if weekday == 6 { ret = "FRI" }
            else if weekday == 7 { ret = "SAT" }
        }
        return ret
    }
    
    func isSame(with date: Date) -> Bool {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.year, .month, .day], from: date)
        let component = calendar.dateComponents([.year, .month, .day], from: self)
         
        if dateComponent.year == component.year,
           dateComponent.month == component.month,
           dateComponent.day == component.day {
            return true
        } else {
            return false
        } 
    }
}
