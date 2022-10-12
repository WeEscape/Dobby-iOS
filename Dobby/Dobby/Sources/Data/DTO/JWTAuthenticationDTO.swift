//
//  JWTAuthenticationDTO.swift
//  Dobby
//
//  Created by yongmin lee on 10/6/22.
//

import Foundation

struct JWTAuthenticationDTO: Codable {
    var aceessToken: String?
    var refreshToken: String?
    
    func toDomain() -> JWTAuthentication {
        return .init(
            accessToken: self.aceessToken,
            refreshToken: self.refreshToken
        )
    }
}
