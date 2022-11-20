//
//  CreateCategoryAPI.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import Foundation
import Moya

struct CreateCategoryAPI: BaseAPI {
    typealias Response = CategoryInfoDTO
    var path: String { "/categories" }
    var method: Moya.Method {
        .post
    }
    var headers: [String: String]? {
        return NetworkServiceImpl.shared.headers
    }
    
    var task: Moya.Task {
        return .requestParameters(
            parameters: [
                "group_id": groupId,
                "category_title": title
            ],
            encoding: JSONEncoding.default
        )
    }
    
    let groupId: String
    let title: String
    
    init(groupId: String, title: String) {
        self.groupId = groupId
        self.title = title
    }
}
