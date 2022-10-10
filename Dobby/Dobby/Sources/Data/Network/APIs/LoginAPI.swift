//
//  LoginAPI.swift
//  Dobby
//
//  Created by yongmin lee on 10/6/22.
//

import Foundation
import Moya

struct LoginAPI: BaseAPI {
    typealias Response = AuthenticationDTO

    var path: String {
        switch provider {
        case .kakao:
            return "/oauth/kakaoLogin"
        case .apple:
            return "/oauth/appleLogin"
        }
    }
    var method: Moya.Method { .post }
    var task: Moya.Task {
        return .requestParameters(
            parameters: [
                "accessToken": accessToken
            ],
            encoding: JSONEncoding.default
        )
    }

    let provider: AuthenticationProvider
    let accessToken: String
    
    init(provider: AuthenticationProvider, accessToken: String) {
        self.provider = provider
        self.accessToken = accessToken
    }
    
}
