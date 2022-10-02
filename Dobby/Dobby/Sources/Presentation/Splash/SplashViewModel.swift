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
    let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    func loadAccessToken() {
        self.authUseCase.readToken(tokenOption: [.accessToken, .refreshToken])
            .subscribe(onNext: { auth in
                
            }).disposed(by: self.disposBag)
    }
    
}
