//
//  ChoreListAPI.swift
//  Dobby
//
//  Created by yongmin lee on 12/6/22.
//

import Foundation
import Moya

struct ChoreListAPI: BaseAPI {
    typealias Response = ChoreListDTO
    var path: String {
        "/tasks/user/\(userId)/\(groupId)/\(date.toStringWithFormat())/\(periodical.rawValue)"
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
    
    let userId: String
    let groupId: String
    let date: Date
    let periodical: ChorePeriodical
    
    init(
        userId: String,
        groupId: String,
        date: Date,
        periodical: ChorePeriodical
    ) {
        self.userId = userId
        self.groupId = groupId
        self.date = date
        self.periodical = periodical
    }
}
