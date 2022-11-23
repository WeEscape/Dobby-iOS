//
//  GroupDTO.swift
//  Dobby
//
//  Created by yongmin lee on 11/19/22.
//

import Foundation

struct GroupDTO: Codable {
    var group: Group?
    var memberList: [User]?
    
    func toDomain() -> Group? {
        var ret = self.group
        ret?.memberList = self.memberList
        return ret
    }
    
    enum CodingKeys: String, CodingKey {
        case group = "group"
        case memberList = "group_user_list"
    }
}
