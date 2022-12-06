//
//  ChoreListDTO.swift
//  Dobby
//
//  Created by yongmin lee on 12/6/22.
//

import Foundation

struct ChoreListDTO: Codable {
    var choreList: [Chore]?
    
    func toDomain() -> [Chore]? {
        guard var choreList = self.choreList else {return nil}
        for (idx, chore) in choreList.enumerated() {
            let cycle = chore.repeatCycle == nil ? ChoreRepeatCycle.off.rawValue : chore.repeatCycle
            choreList[idx].repeatCycle = cycle
        }
        return choreList
    }
    
    enum CodingKeys: String, CodingKey {
        case choreList = "task_list"
    }
}
