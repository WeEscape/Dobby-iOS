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
    
    // authToken
    func readToken(tokenOption: AuthTokenOption) -> Observable<Authentication>
    func writeToken(authentication: Authentication) -> Observable<Void>
    func removeToken(tokenOption: AuthTokenOption) -> Observable<Void>
}
