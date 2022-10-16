//
//  CustomError.swift
//  Dobby
//
//  Created by yongmin lee on 10/16/22.
//

import Foundation

struct CustomError: Error, LocalizedError {
    let memo: String
    
    init(memo: String) {
        self.memo = memo
    }
    
    var errorDescription: String? {
        return self.memo
    }
}
