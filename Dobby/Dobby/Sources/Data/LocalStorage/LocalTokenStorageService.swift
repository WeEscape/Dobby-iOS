//
//  LocalStorageService.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation
import RxSwift

enum TokenKey: String {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
}

protocol LocalTokenStorageService {
    func read(key: TokenKey) -> String?
    func write(key: TokenKey, value: String)
    func delete(key: TokenKey)
}

extension UserDefaults: LocalTokenStorageService {
    func read(key: TokenKey) -> String? {
        return self.object(forKey: key.rawValue) as? String
    }
    
    func write(key: TokenKey, value: String) {
        self.setValue(value, forKey: key.rawValue)
        self.synchronize()
    }
    
    func delete(key: TokenKey) {
        self.removeObject(forKey: key.rawValue)
        self.synchronize()
    }
}
