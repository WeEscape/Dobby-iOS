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
    func saveUserInfoInLocalStorate(user:User)
    func removeUserInfoInLocalStorate()
}

final class UserUseCaseImpl: UserUseCase {
    
    let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func getMyInfo() -> Observable<User> {
        return self.userRepository.getMyInfo()
    }
    
    func saveUserInfoInLocalStorate(user: User) {
        self.userRepository.saveUserInfoInLocalStorate(user: user)
    }
    
    func removeUserInfoInLocalStorate() {
        self.userRepository.removeUserInfoInLocalStorate()
    }
    
}
