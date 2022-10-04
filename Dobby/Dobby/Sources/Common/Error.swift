//
//  Error.swift
//  Dobby
//
//  Created by yongmin lee on 10/4/22.
//

import Foundation

enum Error: LocalizedError {
    case failureAppleAuthorization
    
    var errorDescription: String? {
        switch self {
        case .failureAppleAuthorization:
            return "애플과 연결을 실패했습니다."
        }
    }
}
