//
//  AuthUseCase.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation
import RxSwift

protocol AuthUseCase {
    // oauth
    func snsAuthorize(provider: AuthenticationProvider) -> Observable<Authentication>
    func register(provider: AuthenticationProvider, auth: Authentication) -> Observable<User?>
    func login(
        provider: AuthenticationProvider,
        auth: Authentication
    ) -> Observable<Authentication>
    func logout() -> Observable<Void>
    func resign() -> Observable<Void>
    
    // authToken
    func readToken(tokenOption: TokenOption) -> Observable<Authentication>
    func writeToken(authentication: Authentication)
    func removeToken(tokenOption: TokenOption)
}

final class AuthUseCaseImpl: AuthUseCase {
    
    let authenticationRepository: AuthenticationRepository
    
    init(authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
    }
    
    func snsAuthorize(provider: AuthenticationProvider) -> Observable<Authentication> {
        var snsAuthorize: Observable<Authentication>
        switch provider {
        case .kakao:
            snsAuthorize = self.authenticationRepository.kakaoAuthorize()
        case .apple:
            snsAuthorize = self.authenticationRepository.appleAuthorize()
        }
        return snsAuthorize
    }
    
    func login(
        provider: AuthenticationProvider,
        auth: Authentication
    ) -> Observable<Authentication> {
        return self.authenticationRepository.login(
            provider: provider,
            authentication: auth
        )
    }

    func register(provider: AuthenticationProvider, auth: Authentication) -> Observable<User?> {
        return self.authenticationRepository.register(
            provider: provider,
            auth: auth
        )
    }
    
    func logout() -> Observable<Void> {
        return self.authenticationRepository.logout()
    }
    
    func resign() -> Observable<Void> {
        return self.authenticationRepository.resign()
    }
    
    func readToken(tokenOption: TokenOption) -> Observable<Authentication> {
        return self.authenticationRepository.readToken(tokenOption: tokenOption)
    }
    
    func writeToken(authentication: Authentication) {
        return self.authenticationRepository.writeToken(authentication: authentication)
    }
    
    func removeToken(tokenOption: TokenOption) {
        return self.authenticationRepository.removeToken(tokenOption: tokenOption)
    }
}
