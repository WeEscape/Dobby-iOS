//
//  GroupInfoDTO.swift
//  Dobby
//
//  Created by yongmin lee on 11/19/22.
//

import Foundation

struct GroupInfoDTO: Codable {
    var groupInfo: Group?
    
    func toDomain() -> Group? {
        return self.groupInfo
    }
    
    enum CodingKeys: String, CodingKey {
        case groupInfo = "group_info"
    }
}
