//
//  User.swift
//  Dobby
//
//  Created by yongmin lee on 11/3/22.
//

import Foundation

struct User {
    var id: String
    var social_type: String
    var name: String?
    var profileUrl: String?
    var profileColor: String
    var isConnect: Bool
    var lastConnectedAt: Date?
    var createdAt: Date
    var updatedAt: Date
    var deletedAt: Date?
}
