//
//  RegisterAPI.swift
//  Dobby
//
//  Created by yongmin lee on 11/7/22.
//

import Foundation
import Moya

struct RegisterAPI: BaseAPI {
    typealias Response = UserDTO
    
    var path: String {
        switch provider {
        case .kakao, .apple:
            return "/auth/register"
        }
    }
    var method: Moya.Method { .post }
    var task: Moya.Task {
        switch provider {
        case .kakao:
            return .requestParameters(
                parameters: [
                    "social_access_token": accessToken,
                    "social_type": "kakao"
                ],
                encoding: JSONEncoding.default
            )
        case .apple:
            return .requestParameters(
                parameters: [
                    "social_access_token": accessToken,
                    "social_type": "apple"
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    let provider: AuthenticationProvider
    let accessToken: String

    init(provider: AuthenticationProvider,
         accessToken: String?
    ) {
        self.provider = provider
        self.accessToken = accessToken ?? ""
    }
}
