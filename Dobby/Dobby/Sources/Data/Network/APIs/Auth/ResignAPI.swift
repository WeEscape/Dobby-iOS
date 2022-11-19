//
//  ResignAPI.swift
//  Dobby
//
//  Created by yongmin lee on 11/10/22.
//

import Foundation
import Moya

struct ResignAPI: BaseAPI {
    
    typealias Response = Int
    
    var path: String {"/auth/withdraw"}
    var method: Moya.Method { .post }
    var headers: [String: String]? {
        return NetworkServiceImpl.shared.headers
    }
    var task: Moya.Task {
        .requestPlain
    }
}
