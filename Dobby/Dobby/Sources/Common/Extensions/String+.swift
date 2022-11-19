//
//  String+.swift
//  Dobby
//
//  Created by yongmin lee on 10/30/22.
//

import Foundation

extension String {
    func toDate(dateFormat: String = "yyyy-MM-dd HH:mm:ss Z") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: self)
    }
}

extension String? {
    func isNilOrEmpty() -> Bool {
        guard let self = self else {return true}
        if self.isEmpty {
            return true
        }
        return false
    }
}
