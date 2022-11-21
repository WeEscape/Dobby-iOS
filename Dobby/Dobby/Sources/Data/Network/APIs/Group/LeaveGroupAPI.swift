//
//  LeaveGroupAPI.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import Foundation
import Moya

struct LeaveGroupAPI: BaseAPI {
    typealias Response = GroupDTO
    var path: String {
        "/groups/\(groupId)/user"
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
    
    let groupId: String
    
    init(groupId: String) {
        self.groupId = groupId
    }
}
