//
//  JoinGroupAPI.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import Foundation
import Moya

struct JoinGroupAPI: BaseAPI {
    typealias Response = GroupDTO
    var path: String {
        "/groups/user"
    }
    var method: Moya.Method {
        .post
    }
    var headers: [String: String]? {
        return NetworkServiceImpl.shared.headers
    }
    var task: Moya.Task {
        return .requestParameters(
            parameters: [
                "invite_code": "\(inviteCode)"
            ],
            encoding: JSONEncoding.default
        )
    }
    
    let inviteCode: String
    
    init(inviteCode: String) {
        self.inviteCode = inviteCode
    }
}
