//
//  NetworkError.swift
//  Dobby
//
//  Created by yongmin lee on 10/9/22.
//

import Foundation
import Moya

enum NetworkError : Swift.Error {
    case invalidateRefreshToken
    case invalidateAccessToken
    case denyAuthentication
    case client
    case server
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidateRefreshToken:
            return ""
        case .invalidateAccessToken:
            return ""
        case .denyAuthentication:
            return ""
        case .client:
            return ""
        case .server:
            return ""
        case .unknown:
            return ""
        }
    }
}
