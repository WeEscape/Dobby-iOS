//
//  WelcomeViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation
import RxSwift
import RxRelay
import RxOptional

class WelcomeViewModel {
    
    var disposBag: DisposeBag = .init()
    let authUseCase: AuthUseCase
    let loadingPublish: PublishRelay<Bool>
    var registerTryCount = 0
    let loginResultPublish: PublishRelay<Bool>
    let loginStartPublish: PublishRelay<(AuthenticationProvider, Authentication)>
    let registerStartPublish: PublishRelay<(AuthenticationProvider, Authentication)>
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
        self.loginResultPublish = .init()
        self.loadingPublish = .init()
        self.loginStartPublish = .init()
        self.registerStartPublish = .init()
    }
    
    func snsAuthorize(provider: AuthenticationProvider) {
        self.loadingPublish.accept(true)
        self.authUseCase.snsAuthorize(provider: provider)
            .subscribe(onNext: { [weak self] auth in
                self?.loginStartPublish.accept((provider, auth))
            }).disposed(by: self.disposBag)
    }
    
    func login(provider: AuthenticationProvider, auth: Authentication) {
        self.authUseCase.login(provider: provider, auth: auth)
            .subscribe(
                onNext: { [weak self] auth in
                    self?.loginSuccess(auth: auth)
                }, onError: { [weak self] err in
                    if let networkErr = err as? NetworkError,
                       case .unknown(let code, _) = networkErr,
                       code == 404 { // 회원가입된 유저가 아닌경우 회원가입 진행
                        self?.registerTryCount += 1
                        if (self?.registerTryCount ?? 0) > 3 {
                            self?.loginFail()
                        } else {
                            self?.authUseCase.removeToken(
                                tokenOption: [.accessToken, .refreshToken]
                            )
                            self?.registerStartPublish.accept((provider, auth))
                        }
                    } else {
                        self?.loginFail()
                    }
                }
            ).disposed(by: self.disposBag)
    }
    
    func register(provider: AuthenticationProvider, auth: Authentication) {
        self.authUseCase.register(provider: provider, auth: auth)
            .filterNil()
            .subscribe(onNext: { [weak self] _ in
                self?.loginStartPublish.accept((provider, auth))
            }, onError: { [weak self] _ in
                self?.loginFail()
            }).disposed(by: self.disposBag)
    }
    
    func loginSuccess(auth: Authentication) {
        self.authUseCase.writeToken(authentication: auth)
        self.loginResultPublish.accept(true)
        self.loadingPublish.accept(false)
    }
    
    func loginFail() {
        self.authUseCase.removeToken(tokenOption: [.accessToken, .refreshToken])
        self.loginResultPublish.accept(false)
        self.loadingPublish.accept(false)
    }
}
