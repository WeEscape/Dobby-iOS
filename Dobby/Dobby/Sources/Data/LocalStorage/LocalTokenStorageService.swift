//
//  LocalStorageService.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation
import RxSwift

enum TokenKey: String {
    case jwtAccessToken = "jwtAccessToken"
    case jwtRefreshToken = "jwtRefreshToken"
}

protocol LocalTokenStorageService: AnyObject {
    func read(key: TokenKey) -> String?
    func write(key: TokenKey, value: String)
    func delete(key: TokenKey)
}

extension UserDefaults: LocalTokenStorageService {
    func read(key: TokenKey) -> String? {
        return Self.standard.object(forKey: key.rawValue) as? String
    }
    
    func write(key: TokenKey, value: String) {
        Self.standard.setValue(value, forKey: key.rawValue)
        Self.standard.synchronize()
    }
    
    func delete(key: TokenKey) {
        Self.standard.removeObject(forKey: key.rawValue)
        Self.standard.synchronize()
    }
}
