//
//  AuthenticationRepository.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation
import RxSwift

protocol AuthenticationRepository {
    // oauth
    func kakaoAuthorize() -> Observable<Authentication>
    func appleAuthorize() -> Observable<Authentication>
    func register(provider: AuthenticationProvider, auth: Authentication) -> Observable<User?>
    func login(
        provider: AuthenticationProvider,
        authentication: Authentication
    ) -> Observable<Authentication>
    func logout() -> Observable<Void>
    func resign() -> Observable<Void>
    
    // authToken
    func readToken() -> [String]
    func writeToken(authentication: Authentication)
    func removeToken(tokenOption: TokenOption)
}
