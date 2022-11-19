//
//  CreateGroupAPI.swift
//  Dobby
//
//  Created by yongmin lee on 11/19/22.
//

import Foundation
import Moya

struct CreateGroupAPI: BaseAPI {
    typealias Response = GroupInfoDTO
    var path: String { "/groups" }
    var method: Moya.Method {
        .post
    }
    var headers: [String: String]? {
        var headers = NetworkServiceImpl.shared.headers
        headers["content-type"] = "application/json"
        return headers
    }
    
    var task: Moya.Task {
        return .requestParameters(
            parameters: [
                "group_title": Date().toString()
            ],
            encoding: JSONEncoding.default
        )
    }
}
