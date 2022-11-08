//
//  AuthenticationDTO.swift
//  Dobby
//
//  Created by yongmin lee on 10/6/22.
//

import Foundation

struct AuthenticationDTO: Codable {
    var accessToken: String?
    var refreshToken: String?
    
    func toDomain() -> Authentication {
        return .init(
            accessToken: self.accessToken,
            refreshToken: self.refreshToken
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
