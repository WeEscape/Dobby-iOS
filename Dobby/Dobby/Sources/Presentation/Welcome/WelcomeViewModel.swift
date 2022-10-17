//
//  WelcomeViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation
import RxSwift
import RxRelay

class WelcomeViewModel {
    
    var disposBag: DisposeBag = .init()
    let authUseCase: AuthUseCase
    let loginResult: PublishRelay<Bool>
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
        self.loginResult = .init()
    }
    
    func login(provider: AuthenticationProvider) {
        self.authUseCase.login(provider: provider )
            .subscribe(
                onNext: { [weak self] auth in
                    self?.authUseCase.writeToken(authentication: auth)
                    self?.loginResult.accept(true)
                }, onError: { [weak self]  _ in
                    self?.authUseCase.removeToken(tokenOption: [.accessToken, .refreshToken])
                    self?.loginResult.accept(false)
                }
            ).disposed(by: self.disposBag)
    }
}
