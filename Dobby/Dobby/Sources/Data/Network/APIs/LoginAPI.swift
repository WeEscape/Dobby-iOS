//
//  LoginAPI.swift
//  Dobby
//
//  Created by yongmin lee on 10/6/22.
//

import Foundation
import Moya

struct LoginAPI: BaseAPI {
    typealias Response = JWTAuthenticationDTO
    
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
        switch provider {
        case .kakao:
            return .requestParameters(
                parameters: [
                    "accessToken": accessToken
                ],
                encoding: JSONEncoding.default
            )
        case .apple:
            return .requestParameters(
                parameters: [
                    "identityToken": identityToken,
                    "authorizeCode": authorizeCode
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    let provider: AuthenticationProvider
    let accessToken: String
    let identityToken: String
    let authorizeCode: String
    
    init(provider: AuthenticationProvider,
         accessToken: String?,
         identityToken: String?,
         authorizeCode: String?
    ) {
        self.provider = provider
        self.accessToken = accessToken ?? ""
        self.identityToken = identityToken ?? ""
        self.authorizeCode = authorizeCode ?? ""
    }

}
