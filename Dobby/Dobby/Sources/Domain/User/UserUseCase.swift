//
//  UserUseCase.swift
//  Dobby
//
//  Created by yongmin lee on 11/3/22.
//

import Foundation
import RxSwift

protocol UserUseCase {
    func getMyInfo() -> Observable<User>
}

final class UserUseCaseImpl: UserUseCase {
    
    let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func getMyInfo() -> Observable<User> {
        return self.userRepository.getMyInfo()
    }
}
