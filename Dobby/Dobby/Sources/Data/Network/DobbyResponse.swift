//
//  DobbyResponse.swift
//  Dobby
//
//  Created by yongmin lee on 11/10/22.
//

import Foundation

struct DobbyResponse<T>: Codable where T: Codable {
    var data: T?
    var message: String?
}
