//
//  String+.swift
//  Dobby
//
//  Created by yongmin lee on 10/30/22.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: self)
    }
}
