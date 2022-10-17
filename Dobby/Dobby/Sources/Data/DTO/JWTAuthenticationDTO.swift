//
//  JWTAuthenticationDTO.swift
//  Dobby
//
//  Created by yongmin lee on 10/6/22.
//

import Foundation

struct JWTAuthenticationDTO: Codable {
    var accessToken: String?
    var refreshToken: String?
    
    func toDomain() -> JWTAuthentication {
        return .init(
            accessToken: self.accessToken,
            refreshToken: self.refreshToken
        )
    }
}
