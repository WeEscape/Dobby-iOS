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
                    "social_type": "kakao",
                    "social_id": snsUserId,
                    "user_name": userName,
                    "profile_image_url": profileUrl,
                    "profile_color": "Blue",
                    "authorize_code": authorizeCode
                ],
                encoding: JSONEncoding.default
            )
        case .apple:
            return .requestParameters(
                parameters: [
                    "social_type": "apple",
                    "social_id": snsUserId,
                    "user_name": userName,
                    "profile_image_url": profileUrl,
                    "profile_color": "Blue",
                    "authorize_code": authorizeCode
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    let provider: AuthenticationProvider
    let snsUserId: String
    let userName: String
    let userEmail: String
    let profileUrl: String
    let authorizeCode: String

    init(provider: AuthenticationProvider,
         snsUserId: String?,
         userName: String?,
         userEmail: String?,
         profileUrl: String?,
         authorizeCode: String?
    ) {
        self.provider = provider
        self.snsUserId = snsUserId ?? ""
        self.userName = userName ?? ""
        self.userEmail = userEmail ?? ""
        self.profileUrl = profileUrl ?? ""
        self.authorizeCode = authorizeCode ?? ""
    }
}
