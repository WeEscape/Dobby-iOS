//
//  Category.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import Foundation

struct Category: Codable {
    var categoryId: String?
    var userId: String?
    var groupId: String?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case userId = "user_id"
        case groupId = "group_id"
        case title = "category_title"
    }
}

