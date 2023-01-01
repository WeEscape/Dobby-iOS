//
//  Date+.swift
//  Dobby
//
//  Created by yongmin lee on 10/30/22.
//

import Foundation

extension Date {
    func toStringWithFormat(_ dateFormat: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    func getNextMonth() -> Date {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month, .day], from: self)
        component.month! += 1
        let nextMonth = calendar.date(from: component)
        return nextMonth!
    }
    
    func getLastMonth() -> Date {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month, .day], from: self)
        component.month! -= 1
        let lastMonth = calendar.date(from: component)
        return lastMonth!
    }
    
    func getNextWeek() -> Date {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month, .day], from: self)
        component.day! += 7
        let nextWeek = calendar.date(from: component)
        return nextWeek!
    }
    
    func getLastWeek() -> Date {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month, .day], from: self)
        component.day! -= 7
        let lastWeek = calendar.date(from: component)
        return lastWeek!
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
        let component = calendar.dateComponents([.year, .month, .day, .weekday], from: self)
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
    
    func getDay() -> Int {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .day], from: self)
        return component.day ?? 0
    }
    func getMonth() -> Int {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .day], from: self)
        return component.month ?? 0
    }
    
    func getWeekOfMonth() -> Int {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .weekOfMonth], from: self)
        return component.weekOfMonth ?? 0
    }
    
    func getWeekOfYear() -> Int {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .weekOfYear], from: self)
        return component.weekOfYear ?? 0
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
    
    func getDatesOfSameWeek() -> [Date] {
        let calendar = Calendar.current
        var dateComponent = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: self)
        let myWeekOfYear = dateComponent.weekOfYear!
        var ret: [Date] = .init()
        dateComponent.day! -= 7
        for _ in 0...15 {
            
            let newDate = calendar.date(from: dateComponent)!
            let newDateComponent = calendar.dateComponents([.weekOfYear, .day], from: newDate)
            if let newWeekOfYear = newDateComponent.weekOfYear,
               newWeekOfYear == myWeekOfYear {
                ret.append(newDate)
            }
            
            dateComponent.day! += 1
        }
        return ret
    }
    
    func getFirstDayOfSameMonth() -> Date {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month, .day], from: self)
        while component.day! != 1 {
            component.day! -= 1
        }
        let firstDay = calendar.date(from: component)
        return firstDay!
    }
}
