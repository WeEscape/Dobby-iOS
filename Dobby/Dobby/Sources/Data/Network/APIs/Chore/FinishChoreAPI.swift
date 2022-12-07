//
//  FinishChoreAPI.swift
//  Dobby
//
//  Created by yongmin lee on 12/7/22.
//

import Foundation
import Moya

struct FinishChoreAPI: BaseAPI {
    typealias Response = ChoreDTO
    var path: String {
        "/tasks/\(choreId)/user"
    }
    var method: Moya.Method {
        .put
    }
    var headers: [String: String]? {
        return NetworkServiceImpl.shared.headers
    }
    
    var task: Moya.Task {
        return .requestParameters(
            parameters: [
                "is_end": isEnd ? 1 : 0
            ],
            encoding: JSONEncoding.default
        )
    }
    
    let userId: String
    let choreId: String
    let isEnd: Bool
    
    init(userId: String, choreId: String, isEnd: Bool) {
        self.userId = userId
        self.choreId = choreId
        self.isEnd = isEnd
    }
}
