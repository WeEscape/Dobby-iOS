//
//  SplashViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 10/1/22.
//

import Foundation
import RxSwift
import RxRelay

class SplashViewModel {
    
    var disposBag: DisposeBag = .init()
    let isSignIn: PublishRelay<Bool> = .init()
    let authenticationRepository: AuthenticationRepository
    
    init(authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
    }
    
    func loadAccessToken() {
        print("debug : SplashViewModel loadAccessToken ")
    }
    
}
