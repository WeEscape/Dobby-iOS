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
    
    // MARK: properties
    var disposBag: DisposeBag = .init()
    let loadingPublish: PublishRelay<Bool>
    var registerTryCount = 0
    let authUseCase: AuthUseCase
    let userUseCase: UserUseCase
    
    let loginResultPublish: PublishRelay<Bool>
    let loginStartPublish: PublishRelay<(AuthenticationProvider, Authentication)>
    let registerStartPublish: PublishRelay<(AuthenticationProvider, Authentication)>
    
    // MARK: initialize
    init(authUseCase: AuthUseCase, userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
        self.authUseCase = authUseCase
        self.loginResultPublish = .init()
        self.loadingPublish = .init()
        self.loginStartPublish = .init()
        self.registerStartPublish = .init()
    }
    
    // MARK: methods
    func snsAuthorize(provider: AuthenticationProvider) {
        self.loadingPublish.accept(true)
        self.authUseCase.snsAuthorize(provider: provider)
            .subscribe(onNext: { [weak self] auth in
                self?.loginStartPublish.accept((provider, auth))
            }, onError: { [weak self] _ in
                self?.loginFail()
            }).disposed(by: self.disposBag)
    }
    
    func login(provider: AuthenticationProvider, auth: Authentication) {
        self.authUseCase.login(provider: provider, auth: auth)
            .flatMapLatest { [unowned self] auth -> Observable<User> in
                self.authUseCase.writeToken(authentication: auth)
                return self.userUseCase.getMyInfo()
            }
            .subscribe(onNext: { [weak self] user in
                // 로그인 성공
                self?.userUseCase.saveUserInfoInLocalStorage(user: user)
                self?.loginResultPublish.accept(true)
                self?.loadingPublish.accept(false)
            }, onError: { [weak self] err in
                // 1. 회원가입된 유저가 아닌경우 회원가입 진행
                if let networkErr = err as? NetworkError,
                   case .unknown(let code, _) = networkErr, code == 404 {
                    self?.registerTryCount += 1
                    if (self?.registerTryCount ?? 0) > 3 {
                        // 회원가입 실패
                        self?.loginFail()
                    } else {
                        // 회원가입 시도
                        self?.authUseCase.removeToken(
                            tokenOption: [.accessToken, .refreshToken]
                        )
                        self?.registerStartPublish.accept((provider, auth))
                    }
                } else { // 2. 그외 에러
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
    
    func loginFail() {
        self.userUseCase.removeUserInfoInLocalStorage()
        self.authUseCase.removeToken(tokenOption: [.accessToken, .refreshToken])
        self.loginResultPublish.accept(false)
        self.loadingPublish.accept(false)
    }
}
