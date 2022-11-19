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
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func getMyInfo() -> Observable<User> {
        return self.network.request(api: MyInfoAPI())
            .compactMap { res in
                return res.data?.toDomain()
            }
    }
}
