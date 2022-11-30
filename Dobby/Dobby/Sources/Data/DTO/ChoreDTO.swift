//
//  ChoreDTO.swift
//  Dobby
//
//  Created by yongmin lee on 11/27/22.
//

import Foundation

struct ChoreDTO: Codable {
    var chore: Chore?
    
    func toDomain() -> Chore? {
        var ret = self.chore
        let isNoRepeat = ret?.repeatCycle == nil ? ChoreRepeatCycle.off.rawValue : ret?.repeatCycle
        ret?.repeatCycle = isNoRepeat
        return ret
    }
    
    enum CodingKeys: String, CodingKey {
        case chore = "task"
    }
}
