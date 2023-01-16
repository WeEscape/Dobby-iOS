//
//  UserRepositoryImpl.swift
//  Dobby
//
//  Created by yongmin lee on 11/19/22.
//

import Foundation
import RxSwift

final class UserRepositoryImpl: UserRepository {
    
    let network: NetworkService
    let localStorage: LocalStorageService
    
    init(network: NetworkService, localStorage: LocalStorageService) {
        self.network = network
        self.localStorage = localStorage
    }
    
    func getMyInfo() -> Observable<User> {
        if let localUser = self.localStorage.getUser() {
            return .just(localUser)
        }
        return self.network.request(api: MyInfoAPI())
            .compactMap { res in
                return res.data?.toDomain()
            }
    }
    
    func saveUserInfoInLocalStorage(user: User) {
        self.localStorage.saveUser(user)
    }
    
    func removeUserInfoInLocalStorage() {
        self.localStorage.delete(key: .userInfo)
    }
    
}
