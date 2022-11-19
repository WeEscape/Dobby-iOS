//
//  LogoutAPI.swift
//  Dobby
//
//  Created by yongmin lee on 11/10/22.
//

import Foundation
import Moya

struct LogoutAPI: BaseAPI {
    
    typealias Response = Int
    
    var path: String {
        return "/auth/logout"
    }
    var method: Moya.Method { .post }
    var headers: [String: String]? {
        var headers = NetworkServiceImpl.shared.headers
        headers["content-type"] = "application/json"
        return headers
    }
    var task: Moya.Task {
        .requestPlain
    }
}
