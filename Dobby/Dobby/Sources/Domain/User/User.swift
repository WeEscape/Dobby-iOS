//
//  User.swift
//  Dobby
//
//  Created by yongmin lee on 11/3/22.
//

import Foundation

struct User: Codable {
    var userId: String
    var socialId: String
    var socialType: String
    var name: String?
    var profileUrl: String?
    var profileColor: String?
    var isConnect: Int
    var groupIds: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case socialId = "social_id"
        case socialType = "social_type"
        case name = "name"
        case profileUrl = "profile_url"
        case profileColor = "profile_color"
        case isConnect = "is_connect"
        case groupIds = "group_ids"
    }
}
