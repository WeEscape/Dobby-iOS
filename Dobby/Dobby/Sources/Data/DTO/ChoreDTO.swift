//
//  ChoreDTO.swift
//  Dobby
//
//  Created by yongmin lee on 11/27/22.
//

import Foundation

struct ChoreDTO: Codable {
    var chore: Chore?
    var ownerList: [ChoreOwner]?
    
    func toDomain() -> Chore? {
        var ret = self.chore
        ret?.ownerList = self.ownerList ?? []
        let isNoRepeat = ret?.repeatCycle == nil ? ChoreRepeatCycle.off.rawValue : ret?.repeatCycle
        ret?.repeatCycle = isNoRepeat
        return ret
    }
    
    enum CodingKeys: String, CodingKey {
        case chore = "task"
        case ownerList = "task_user_list"
    }
}
