//
//  Authentication.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation

struct Authentication: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let identityToken: String?
    let authorizeCode: String?
    let snsUserName: String?
    let snsUserEmail: String?
    let snsUserId: String?
    
    init(
        accessToken: String?,
        refreshToken: String?,
        identityToken: String? = nil,
        authorizeCode: String? = nil,
        snsUserName: String? = nil,
        snsUserEmail: String? = nil,
        snsUserId: String? = nil
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.identityToken = identityToken
        self.authorizeCode = authorizeCode
        self.snsUserName = snsUserName
        self.snsUserEmail = snsUserEmail
        self.snsUserId = snsUserId
    }
}

enum AuthenticationProvider: Int {
    case kakao
    case apple
}

struct TokenOption: OptionSet {
    let rawValue: Int
    static let accessToken =  TokenOption(rawValue: 1 << 0)
    static let refreshToken = TokenOption(rawValue: 1 << 1)
}
