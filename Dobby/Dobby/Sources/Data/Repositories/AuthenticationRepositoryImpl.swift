//
//  AuthenticationRepositoryImpl.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import UIKit
import RxSwift
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import RxOptional

final class AuthenticationRepositoryImpl: AuthenticationRepository {
    
    let network: NetworkService
    let localStorage: LocalTokenStorageService
    
    init(network: NetworkService, localStorage: LocalTokenStorageService) {
        self.network = network
        self.localStorage = localStorage
    }
    
    func kakaoAuthorize() -> Observable<Authentication> {
        return Observable<Authentication>.create { observer in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { respone, error in
                    if let err = error {
                        BeaverLog.debug(err.localizedDescription)
                        observer.on(.error(err))
                    } else {
                        observer.on(.next(.init(
                            accessToken: respone?.accessToken,
                            refreshToken: respone?.refreshToken,
                            identityToken: nil,
                            authorizeCode: nil,
                            snsUserName: nil,
                            snsUserEmail: nil,
                            snsUserId: nil
                        )))
                        observer.onCompleted()
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { respone, error in
                    if let err = error {
                        BeaverLog.debug(err.localizedDescription)
                        observer.on(.error(err))
                    } else {
                        observer.on(.next(.init(
                            accessToken: respone?.accessToken,
                            refreshToken: respone?.refreshToken,
                            identityToken: nil,
                            authorizeCode: nil,
                            snsUserName: nil,
                            snsUserEmail: nil,
                            snsUserId: nil
                        )))
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func appleAuthorize() -> Observable<Authentication> {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.performRequests()
        
        return controller.rx.didCompleteAuthorization
            .filterNil()
            .first()
            .asObservable()
            .filterNil()
    }
    
    func login(
        provider: AuthenticationProvider,
        authentication: Authentication
    ) -> Observable<JWTAuthentication> {
        return self.network.request(api: LoginAPI(
            provider: provider,
            accessToken: authentication.accessToken,
            refreshToken: authentication.refreshToken,
            snsUserName: authentication.snsUserName,
            snsUserEmail: authentication.snsUserEmail,
            snsUserId: authentication.snsUserId,
            identityToken: authentication.identityToken,
            authorizeCode: authentication.authorizeCode
        )).map { authDTO in
            return authDTO.toDomain()
        }
    }
    
    func logout() -> Observable<Void> {
        return .empty()
    }
    
    func resign() -> Observable<Void> {
        return .empty()
    }
    
    func readToken(tokenOption: TokenOption) -> Observable<JWTAuthentication> {
        var tokenList: [String?] = []
        if tokenOption.contains(.accessToken) {
            tokenList.append(self.localStorage.read(key: .jwtAccessToken))
        }
        if tokenOption.contains(.refreshToken) {
            tokenList.append(self.localStorage.read(key: .jwtRefreshToken))
        }
        return Observable.just(JWTAuthentication(
            accessToken: tokenList[safe: 0] ?? nil,
            refreshToken: tokenList[safe: 1] ?? nil
        ))
    }
    
    func writeToken(authentication: JWTAuthentication) {
        if let accessToken = authentication.accessToken {
            self.localStorage.write(key: .jwtAccessToken, value: accessToken)
        }
        if let refreshToken = authentication.refreshToken {
            self.localStorage.write(key: .jwtRefreshToken, value: refreshToken)
        }
    }
    
    func removeToken(tokenOption: TokenOption) {
        if tokenOption.contains(.accessToken) {
            self.localStorage.delete(key: .jwtAccessToken)
        }
        if tokenOption.contains(.refreshToken) {
            self.localStorage.delete(key: .jwtRefreshToken)
        }
    }
}
