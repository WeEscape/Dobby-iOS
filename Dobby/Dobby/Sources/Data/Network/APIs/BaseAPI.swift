//
//  BaseAPI.swift
//  Dobby
//
//  Created by yongmin lee on 10/6/22.
//

import Foundation
import Moya

protocol BaseAPI: TargetType {
    associatedtype Response: Codable
    var baseURL: URL { get }
    var headers: [String: String]? { get }
    var path: String { get }
    var method: Moya.Method { get }
    var task: Moya.Task { get }
}

extension BaseAPI {
    var baseURL: URL {
        return URL(string: "http://118.67.128.228:3000")!
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json;charset=UTF-8",
        ]
    }
}
