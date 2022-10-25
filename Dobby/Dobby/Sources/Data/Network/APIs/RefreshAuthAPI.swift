//
//  AuthRefreshAPI.swift
//  Dobby
//
//  Created by yongmin lee on 10/9/22.
//

import Foundation
import Moya

struct AuthRefreshAPI: BaseAPI {
    typealias Response = AuthenticationDTO
    var path: String = ""
    var method: Moya.Method {
        .get
    }
    var task: Moya.Task {
        .requestPlain
    }
    var refreshToken: String
    
    init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}
