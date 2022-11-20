//
//  CategoryListDTO.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import Foundation

struct CategoryListDTO: Codable {
    var categoryList: [Category]?
    
    func toDomain() -> [Category]? {
        return self.categoryList
    }
    
    enum CodingKeys: String, CodingKey {
        case categoryList = "category_list"
    }
}
