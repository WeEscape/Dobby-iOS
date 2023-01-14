//
//  LocalStorageService.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation

enum LocalKey: String {
    case accessToken
    case refreshToken
    case userInfo
    case alarmOnOff
    case alarmTime
    case lastUpdateAt
}

protocol LocalStorageService: AnyObject {
    func read(key: LocalKey) -> String?
    func write(key: LocalKey, value: String)
    func delete(key: LocalKey)
    func saveUser(_ user: User)
    func getUser() -> User?
    func clear()
}
