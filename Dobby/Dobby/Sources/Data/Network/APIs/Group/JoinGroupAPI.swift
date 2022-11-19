//
//  JoinGroupAPI.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import Foundation
import Moya

struct JoinGroupAPI: BaseAPI {
    typealias Response = GroupInfoDTO
    var path: String {
        "/groups/\(groupId)/user"
    }
    var method: Moya.Method {
        .post
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
