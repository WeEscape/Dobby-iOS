//
//  AuthUseCase.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation
import RxSwift
import WatchConnectivity

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
    func readToken() -> Observable<Authentication>
    func writeToken(authentication: Authentication)
    func removeToken(tokenOption: TokenOption)
    func createTokenContext() -> [String: String]
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
    
    func readToken() -> Observable<Authentication> {
        let tokenList = self.authenticationRepository.readToken()
        return Observable.just(Authentication(
            accessToken: tokenList[safe: 0],
            refreshToken: tokenList[safe: 1]
        ))
    }
    
    func writeToken(authentication: Authentication) {
        self.authenticationRepository.writeToken(authentication: authentication)
        self.updateWatchToken()
    }
    
    func removeToken(tokenOption: TokenOption) {
        self.authenticationRepository.removeToken(tokenOption: tokenOption)
        self.updateWatchToken()
    }
    
    func createTokenContext() -> [String: String] {
        let tokenList = self.authenticationRepository.readToken()
        let ret: [String: String] = [
            LocalKey.accessToken.rawValue: tokenList.first ?? "",
            LocalKey.refreshToken.rawValue: tokenList.last ?? "",
            LocalKey.lastUpdateAt.rawValue: Date().toStringWithFormat("yyyy-MM-dd HH:mm:ss")
        ]
        return ret
    }
    
    func updateWatchToken() {
        let context = self.createTokenContext()
        try? WCSession.default.updateApplicationContext(context)
    }
}
