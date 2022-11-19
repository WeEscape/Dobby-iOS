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
                    "social_id": snsUserId
                ],
                encoding: JSONEncoding.default
            )
        case .apple:
            return .requestParameters(
                parameters: [
                    "social_type": "apple",
                    "social_id": snsUserId
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    let provider: AuthenticationProvider
    let snsUserId: String
    
    init(provider: AuthenticationProvider,
         snsUserId: String?
    ) {
        self.provider = provider
        self.snsUserId = snsUserId ?? ""
    }
}
