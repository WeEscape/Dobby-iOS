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
            return "/auth/login"
        }
    }
    var method: Moya.Method { .post }
    var task: Moya.Task {
        switch provider {
        case .kakao:
            return .requestParameters(
                parameters: [
                    "social_type": "kakao",
                    "social_user_id": snsUserId
                ],
                encoding: JSONEncoding.default
            )
        case .apple:
            return .requestParameters(
                parameters: [
                    "social_type": "apple",
                    "social_user_id": snsUserId
//                    "snsUserName": snsUserName,
//                    "snsUserEmail": snsUserEmail,
//                    "identityToken": identityToken,
//                    "authorizeCode": authorizeCode
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    let provider: AuthenticationProvider
    let snsUserId: String
//    let accessToken: String
//    let refreshToken: String
//    let identityToken: String
//    let authorizeCode: String
//    let snsUserName: String
//    let snsUserEmail: String
    
    init(provider: AuthenticationProvider,
         snsUserId: String?
//         accessToken: String?,
//         refreshToken: String?,
//         snsUserName: String?,
//         snsUserEmail: String?,
//         identityToken: String?,
//         authorizeCode: String?
    ) {
        self.provider = provider
        self.snsUserId = snsUserId ?? ""
//        self.accessToken = accessToken ?? ""
//        self.refreshToken = refreshToken ?? ""
//        self.snsUserName = snsUserName ?? ""
//        self.snsUserEmail = snsUserEmail ?? ""
//        self.identityToken = identityToken ?? ""
//        self.authorizeCode = authorizeCode ?? ""
    }
}
