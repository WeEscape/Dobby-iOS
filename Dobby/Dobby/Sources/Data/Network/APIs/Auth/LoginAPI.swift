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
        case .kakao, .apple:
            return "/login"
        }
    }
    var method: Moya.Method { .post }
    var task: Moya.Task {
        switch provider {
        case .kakao:
            return .requestParameters(
                parameters: [
                    "access_token": accessToken,
//                    "refreshToken": refreshToken,
                    "social_type": "kakao"
                ],
                encoding: JSONEncoding.default
            )
        case .apple:
            return .requestParameters(
                parameters: [
                    "snsUserName": snsUserName,
                    "snsUserEmail": snsUserEmail,
                    "snsUserId": snsUserId,
                    "identityToken": identityToken,
                    "authorizeCode": authorizeCode
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    let provider: AuthenticationProvider
    let accessToken: String
    let refreshToken: String
    let identityToken: String
    let authorizeCode: String
    let snsUserName: String
    let snsUserEmail: String
    let snsUserId: String
    
    init(provider: AuthenticationProvider,
         accessToken: String?,
         refreshToken: String?,
         snsUserName: String?,
         snsUserEmail: String?,
         snsUserId: String?,
         identityToken: String?,
         authorizeCode: String?
    ) {
        self.provider = provider
        self.accessToken = accessToken ?? ""
        self.refreshToken = refreshToken ?? ""
        self.snsUserName = snsUserName ?? ""
        self.snsUserEmail = snsUserEmail ?? ""
        self.snsUserId = snsUserId ?? ""
        self.identityToken = identityToken ?? ""
        self.authorizeCode = authorizeCode ?? ""
    }

}
