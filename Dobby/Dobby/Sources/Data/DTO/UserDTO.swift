//
//  UserDTO.swift
//  Dobby
//
//  Created by yongmin lee on 11/8/22.
//

import Foundation

struct UserDTO: Codable {
    var user: User?
    var groupList: [Group]?
    
    func toDomain() -> User? {
        var ret = self.user
        ret?.groupList = self.groupList
        return ret
    }
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
        case groupList = "group_list"
    }
}
