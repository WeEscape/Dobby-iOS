//
//  GroupInfoAPI.swift
//  Dobby
//
//  Created by yongmin lee on 11/19/22.
//

import Foundation
import Moya

struct GroupInfoAPI: BaseAPI {
    typealias Response = GroupDTO
    var path: String {
        "/groups/\(groupId)"
    }
    var method: Moya.Method {
        .get
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
