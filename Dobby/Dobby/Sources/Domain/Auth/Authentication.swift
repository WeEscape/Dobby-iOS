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
}

struct AuthTokenOption: OptionSet {
    let rawValue: Int
    static let accessToken =  AuthTokenOption(rawValue: 1 << 0)
    static let refreshToken = AuthTokenOption(rawValue: 1 << 1)
}

enum AuthenticationProvider: Int {
    case kakao
    case apple
}
