//
//  UserInfoDTO.swift
//  Dobby
//
//  Created by yongmin lee on 11/19/22.
//

import Foundation

struct UserInfoDTO: Codable {
    var userInfo: User?
    
    func toDomain() -> User? {
        return self.userInfo
    }
    
    enum CodingKeys: String, CodingKey {
        case userInfo = "user_info"
    }
}
