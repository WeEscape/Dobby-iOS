//
//  CategoryListAPI.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import Foundation
import Moya

struct CategoryListAPI: BaseAPI {
    typealias Response = CategoryListDTO
    var path: String {
        "/categories/group/\(groupId)"
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
