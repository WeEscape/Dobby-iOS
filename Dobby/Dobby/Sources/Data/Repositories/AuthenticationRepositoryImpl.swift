//
//  AuthenticationRepositoryImpl.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation
import RxSwift

final class AuthenticationRepositoryImpl: AuthenticationRepository {
    
    let network: NetworkService
    let localStorage: LocalTokenStorageService
    
    init(network: NetworkService, localStorage: LocalTokenStorageService) {
        self.network = network
        self.localStorage = localStorage
    }
    
    func kakaoAuthorize() -> Observable<Authentication> {
        return .empty()
    }
    
    func appleAuthorize() -> Observable<Authentication> {
        return .empty()
    }
    
    func logout() -> Observable<Void> {
        return .empty()
    }
    
    func resign() -> Observable<Void> {
        return .empty()
    }
    
    func readToken(tokenOption: AuthTokenOption) -> Observable<Authentication> {
        var tokenList: [String?] = []
        if tokenOption.contains(.accessToken)  {
            tokenList.append(self.localStorage.read(key: .accessToken))
        }
        if tokenOption.contains(.refreshToken) {
            tokenList.append(self.localStorage.read(key: .refreshToken))
        }
        return Observable.just(Authentication(
            accessToken: tokenList[safe: 0] ?? nil,
            refreshToken: tokenList[safe: 1] ?? nil
        ))
    }
    
    func writeToken(authentication: Authentication) -> Observable<Void> {
        return .empty()
    }
    
    func removeToken(tokenOption: AuthTokenOption) -> Observable<Void> {
        return .empty()
    }
}
