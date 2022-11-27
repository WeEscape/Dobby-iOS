//
//  CreateChoreAPI.swift
//  Dobby
//
//  Created by yongmin lee on 11/27/22.
//

import Foundation
import Moya

struct CreateChoreAPI: BaseAPI {
    typealias Response = ChoreDTO
    var path: String { "/tasks" }
    var method: Moya.Method {
        .post
    }
    var headers: [String: String]? {
        return NetworkServiceImpl.shared.headers
    }
    
    var task: Moya.Task {
        var params: [String: Any] = [
            "category_id": chore.categoryId,
            "task_title": chore.title,
            "memo": chore.memo ?? "",
            "notice_available": chore.noticeEnable,
            "end_repeat_at": chore.endAt,
            "excute_at": chore.executeAt,
            "add_user_ids": self.ownerList,
        ]
        
        if chore.repeatCycle != ChoreRepeatCycle.off.rawValue {
            params["repeat_cycle"] = chore.repeatCycle
        }
        
        return .requestParameters(
            parameters: params,
            encoding: JSONEncoding.default
        )
    }
    
    let chore: Chore
    let ownerList: [String]
    
    init(chore: Chore, ownerList: [String]) {
        self.chore = chore
        self.ownerList = ownerList
    }
}
