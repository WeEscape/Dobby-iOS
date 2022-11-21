//
//  CategoryInfoDTO.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import Foundation

struct CategoryDTO: Codable {
    var category: Category?
    
    func toDomain() -> Category? {
        return self.category
    }
    
    enum CodingKeys: String, CodingKey {
        case category = "category"
    }
}
