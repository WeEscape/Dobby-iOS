//
//  LoginAPI.swift
//  Dobby
//
//  Created by yongmin lee on 10/6/22.
//

import Foundation
import Moya

struct LoginAPI: BaseAPI {
    typealias Response = AuthenticationDTO
    
    var path: String
    
    var method: Moya.Method
    
    var task: Moya.Task
}
