//
//  Chore.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import Foundation

struct Chore {
    var title: String
    var categoryId: String
    var repeatCycle: ChoreRepeatCycle
    var noticeEnable: Int
    var executeAt: Date
    var endAt: Date
    var ownerList : [String] // id list
    var memo: String?
}
