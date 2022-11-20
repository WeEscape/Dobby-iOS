//
//  CategoryInfoDTO.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import Foundation

struct CategoryInfoDTO: Codable {
    var categoryInfo: Category?
    
    func toDomain() -> Category? {
        return self.categoryInfo
    }
    
    enum CodingKeys: String, CodingKey {
        case categoryInfo = "category_info"
    }
}
