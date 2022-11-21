//
//  GroupDTO.swift
//  Dobby
//
//  Created by yongmin lee on 11/19/22.
//

import Foundation

struct GroupDTO: Codable {
    var group: Group?
    
    func toDomain() -> Group? {
        return self.group
    }
    
    enum CodingKeys: String, CodingKey {
        case group = "group"
    }
}
