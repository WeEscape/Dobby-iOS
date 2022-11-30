//
//  Chore.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import Foundation

struct Chore: Codable {
    var choreId: String
    var title: String
    var categoryId: String
    var repeatCycle: String?
    var noticeEnable: Int
    var executeAt: String
    var endAt: String
    var ownerList: [ChoreOwner]?
    var memo: String?
    
    enum CodingKeys: String, CodingKey {
        case choreId = "task_id"
        case title = "task_title"
        case categoryId = "category_id"
        case repeatCycle = "repeat_cycle"
        case memo = "memo"
        case noticeEnable = "notice_available"
        case endAt = "end_repeat_at"
        case executeAt = "excute_at"
        case ownerList = "task_user_list"
    }
}
