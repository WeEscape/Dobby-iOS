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
        self.authUseCase.readToken()
            .subscribe(onNext: { [weak self] auth in
                if let accessToken = auth.accessToken,
                   accessToken.isEmpty == false,
                   let refreshToken = auth.refreshToken,
                   refreshToken.isEmpty == false {
                    self?.isSignIn.accept(true)
                } else {
                    self?.isSignIn.accept(false)
                }
            }).disposed(by: self.disposBag)
    }
}
