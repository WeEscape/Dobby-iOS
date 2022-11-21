//
//  MyInfoAPI.swift
//  Dobby
//
//  Created by yongmin lee on 11/19/22.
//

import Foundation
import Moya

struct MyInfoAPI: BaseAPI {
    typealias Response = UserDTO
    var path: String { "/users/my" }
    var method: Moya.Method { .get }
    var task: Moya.Task { .requestPlain }
    var headers: [String: String]? {
        return NetworkServiceImpl.shared.headers
    }
}
