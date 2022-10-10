//
//  AuthenticationDTO.swift
//  Dobby
//
//  Created by yongmin lee on 10/6/22.
//

import Foundation

struct AuthenticationDTO: Codable {
    var aceessToken: String?
    var refreshToken: String?
    
    func toDomain() -> Authentication {
        return .init(
            accessToken: self.aceessToken,
            refreshToken: self.refreshToken
        )
    }
}
