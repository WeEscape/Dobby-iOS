//
//  UserDTO.swift
//  Dobby
//
//  Created by yongmin lee on 11/8/22.
//

import Foundation

struct UserDTO: Codable {
    var user: User?
    
    func toDomain() -> User? {
        return self.user
    }
}
