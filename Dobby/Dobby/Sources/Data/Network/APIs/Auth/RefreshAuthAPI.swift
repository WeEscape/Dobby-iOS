//
//  AuthRefreshAPI.swift
//  Dobby
//
//  Created by yongmin lee on 10/9/22.
//

import Foundation
import Moya

struct AuthRefreshAPI: BaseAPI {
    typealias Response = AuthenticationDTO
    var path: String = "/auth/tokens"
    var method: Moya.Method {
        .post
    }
    var task: Moya.Task {
        return .requestParameters(
            parameters: [
                "refresh_token": refreshToken
            ],
            encoding: JSONEncoding.default
        )
    }
    var refreshToken: String
    
    init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}
