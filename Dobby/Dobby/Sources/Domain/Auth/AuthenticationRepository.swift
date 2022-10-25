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
    func logout() -> Observable<Void>
    func resign() -> Observable<Void>
    func login(
        provider: AuthenticationProvider,
        authentication: Authentication
    ) -> Observable<Authentication>
    
    // authToken
    func readToken(tokenOption: TokenOption) -> Observable<Authentication>
    func writeToken(authentication: Authentication)
    func removeToken(tokenOption: TokenOption)
}
