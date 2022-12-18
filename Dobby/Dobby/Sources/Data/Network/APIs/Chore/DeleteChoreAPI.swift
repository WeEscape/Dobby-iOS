//
//  DeleteChoreAPI.swift
//  Dobby
//
//  Created by yongmin lee on 12/18/22.
//

import Foundation
import Moya

struct DeleteChoreAPI: BaseAPI {
    typealias Response = ChoreDTO
    var path: String {
        "/tasks/\(choreId)"
    }
    var method: Moya.Method {
        .delete
    }
    var headers: [String: String]? {
        return NetworkServiceImpl.shared.headers
    }
    
    var task: Moya.Task {
        .requestPlain
    }
    
    let choreId: String
    
    init(choreId: String) {
        self.choreId = choreId
    }
}
