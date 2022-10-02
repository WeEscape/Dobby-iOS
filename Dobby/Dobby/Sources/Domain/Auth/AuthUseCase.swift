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
    func kakaoAuthorize() -> Observable<Authentication>
    func appleAuthorize() -> Observable<Authentication>
    func logout() -> Observable<Void>
    func resign() -> Observable<Void>
    
    // authToken
    func readToken(tokenOption: AuthTokenOption) -> Observable<Authentication>
    func writeToken(authentication: Authentication) -> Observable<Void>
    func removeToken(tokenOption: AuthTokenOption) -> Observable<Void>
}

final class AuthUseCaseImpl: AuthUseCase {
    
    let authenticationRepository: AuthenticationRepository
    
    init(authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
    }
    
    func kakaoAuthorize() -> Observable<Authentication> {
        return self.authenticationRepository.kakaoAuthorize()
    }
    
    func appleAuthorize() -> Observable<Authentication> {
        return self.authenticationRepository.appleAuthorize()
    }
    
    func logout() -> Observable<Void> {
        return self.authenticationRepository.logout()
    }
    
    func resign() -> Observable<Void> {
        return self.authenticationRepository.resign()
    }
    
    func readToken(tokenOption: AuthTokenOption) -> Observable<Authentication> {
        return self.authenticationRepository.readToken(tokenOption: tokenOption)
    }
    
    func writeToken(authentication: Authentication) -> Observable<Void> {
        return self.authenticationRepository.writeToken(authentication: authentication)
    }
    
    func removeToken(tokenOption: AuthTokenOption) -> Observable<Void> {
        return self.authenticationRepository.removeToken(tokenOption: tokenOption)
    }
}