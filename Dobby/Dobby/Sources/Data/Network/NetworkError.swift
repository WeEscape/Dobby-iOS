//
//  NetworkError.swift
//  Dobby
//
//  Created by yongmin lee on 10/9/22.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidateAccessToken
    case invalidateRefreshToken
    case client
    case server
    case decoding
    case unknown(_ code: Int, _ message: String?)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidateAccessToken:
            return "Network error : 유효하지 않은 access token"
        case .invalidateRefreshToken:
            return "Network error : 유효하지 않은 refresh token"
        case .client:
            return "Network error : 클라이언트 잘못된 요청"
        case .server:
            return "Network error : 서버 내부 에러"
        case .decoding:
            return "Network error : 디코딩 에러"
        case .unknown(let code, let message):
            return "Network error : \(code), \(message ?? "")"
        }
    }
}

struct ErrorResponse: Codable {
    var message: String?
}
