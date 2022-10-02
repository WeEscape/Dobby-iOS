//
//  Array+.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        get {
            guard indices ~= index else { return nil }
            return self[index]
        }
    }
}
