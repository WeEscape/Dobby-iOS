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
}

enum AuthenticationProvider: Int {
    case kakao
    case apple
}
