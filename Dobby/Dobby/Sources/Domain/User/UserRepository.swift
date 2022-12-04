//
//  UserRepository.swift
//  Dobby
//
//  Created by yongmin lee on 11/19/22.
//

import Foundation
import RxSwift

protocol UserRepository {
    func getMyInfo() -> Observable<User>
    func saveUserInfoInLocalStorate(user: User)
    func removeUserInfoInLocalStorate()
}
