//
//  ChoreOwner.swift
//  Dobby
//
//  Created by yongmin lee on 11/27/22.
//

import Foundation

struct ChoreOwner: Codable {
    var taskId: String?
    var userId: String
    var isEnd: Int
    
    enum CodingKeys: String, CodingKey {
        case taskId = "task_id"
        case userId = "user_id"
        case isEnd = "is_end"
    }
}
