//
//  Group.swift
//  Dobby
//
//  Created by yongmin lee on 11/19/22.
//

import Foundation

struct Group: Codable {
    var groupId: String?
    var title: String?
    var inviteCode: String?
    var memberList: [User]?
    
    enum CodingKeys: String, CodingKey {
        case groupId = "group_id"
        case title = "group_title"
        case inviteCode = "invite_code"
        case memberList = "member_list"
    }
}
