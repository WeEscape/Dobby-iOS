//
//  AuthenticationRepositoryImpl.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation
import RxSwift

final class AuthenticationRepositoryImpl: AuthenticationRepository {
    
    func kakaoAuthorize() -> RxSwift.Observable<Authentication> {
        return .empty()
    }
    
    func appleAuthorize() -> RxSwift.Observable<Authentication> {
        return .empty()
    }
    
    func logout() -> RxSwift.Observable<Void> {
        return .empty()
    }
    
    func resign() -> RxSwift.Observable<Void> {
        return .empty()
    }
    
    func readToken(tokenOption: AuthTokenOption) -> RxSwift.Observable<Authentication> {
        return .empty()
    }
    
    func writeToken(authentication: Authentication) -> RxSwift.Observable<Void> {
        return .empty()
    }
    
    func removeToken(tokenOption: AuthTokenOption) -> RxSwift.Observable<Void> {
        return .empty()
    }
}
