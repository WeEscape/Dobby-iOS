//
//  JWTAuthentication.swift
//  Dobby
//
//  Created by yongmin lee on 10/12/22.
//

import Foundation

struct JWTAuthentication: Decodable {
    let accessToken: String?
    let refreshToken: String?
}

struct TokenOption: OptionSet {
    let rawValue: Int
    static let accessToken =  TokenOption(rawValue: 1 << 0)
    static let refreshToken = TokenOption(rawValue: 1 << 1)
}
