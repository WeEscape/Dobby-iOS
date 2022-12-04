//
//  LocalStorageService.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation
import RxSwift

enum LocalKey: String {
    case jwtAccessToken = "jwtAccessToken"
    case jwtRefreshToken = "jwtRefreshToken"
    case userInfo = "userInfo"
}

protocol LocalStorageService: AnyObject {
    func read(key: LocalKey) -> String?
    func write(key: LocalKey, value: String)
    func delete(key: LocalKey)
    func saveUser(_ user: User)
    func getUser() -> User?
}

extension UserDefaults: LocalStorageService {
    func read(key: LocalKey) -> String? {
        return Self.standard.object(forKey: key.rawValue) as? String
    }
    
    func write(key: LocalKey, value: String) {
        Self.standard.setValue(value, forKey: key.rawValue)
        Self.standard.synchronize()
    }
    
    func delete(key: LocalKey) {
        Self.standard.setValue(nil, forKey: key.rawValue)
        Self.standard.synchronize()
    }
    
    func saveUser(_ user: User) {
        let encoder = JSONEncoder()
        let encodedUser = try? encoder.encode(user)
        Self.standard.setValue(encodedUser, forKey: LocalKey.userInfo.rawValue)
        Self.standard.synchronize()
    }
    
    func getUser() -> User? {
        if let data = UserDefaults.standard.object(forKey: LocalKey.userInfo.rawValue) as? Data {
            let decoder = JSONDecoder()
            let savedUser = try? decoder.decode(User.self, from: data)
                return savedUser
            
        }
        return nil
    }
}
