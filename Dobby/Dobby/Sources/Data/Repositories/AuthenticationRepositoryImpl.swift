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
    let localStorage: LocalStorageService
    
    init(network: NetworkService, localStorage: LocalStorageService) {
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
                        UserApi.shared.me { user, err in
                            if let err = error {
                                BeaverLog.debug(err.localizedDescription)
                                observer.on(.error(err))
                            } else {
                                guard let userId = user?.id else {
                                    BeaverLog.debug("error: no kakao user id")
                                    observer.on(.error(CustomError(memo: "no kakao user id")))
                                    return
                                }
                                observer.on(.next(.init(
                                    accessToken: respone?.accessToken,
                                    refreshToken: respone?.refreshToken,
                                    identityToken: nil,
                                    authorizeCode: nil,
                                    snsUserName: user?.kakaoAccount?.profile?.nickname,
                                    snsUserEmail: user?.kakaoAccount?.email,
                                    snsUserId: String(userId),
                                    snsProfileUrl: user?.kakaoAccount?.profile?.profileImageUrl?.absoluteString
                                )))
                                observer.onCompleted()
                            }
                        }
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { respone, error in
                    if let err = error {
                        BeaverLog.debug(err.localizedDescription)
                        observer.on(.error(err))
                    } else {
                        UserApi.shared.me { user, err in
                            if let err = error {
                                BeaverLog.debug(err.localizedDescription)
                                observer.on(.error(err))
                            } else {
                                guard let userId = user?.id else {
                                    BeaverLog.debug("error: no kakao user id")
                                    observer.on(.error(CustomError(memo: "no kakao user id")))
                                    return
                                }
                                observer.on(.next(.init(
                                    accessToken: respone?.accessToken,
                                    refreshToken: respone?.refreshToken,
                                    identityToken: nil,
                                    authorizeCode: nil,
                                    snsUserName: user?.kakaoAccount?.profile?.nickname,
                                    snsUserEmail: user?.kakaoAccount?.email,
                                    snsUserId: String(userId),
                                    snsProfileUrl: user?.kakaoAccount?.profile?.profileImageUrl?.absoluteString
                                )))
                                observer.onCompleted()
                            }
                        }
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
    ) -> Observable<Authentication> {
        return self.network.request(api: LoginAPI(
            provider: provider,
            snsUserId: authentication.snsUserId
        ))
        .compactMap { res in
            return res.data?.toDomain()
        }
    }
    
    func register(provider: AuthenticationProvider, auth: Authentication) -> Observable<User?> {
        return self.network.request(api: RegisterAPI(
            provider: provider,
            snsUserId: auth.snsUserId,
            userName: auth.snsUserName,
            userEmail: auth.snsUserEmail,
            profileUrl: auth.snsProfileUrl,
            authorizeCode: auth.authorizeCode
        ))
        .compactMap { res in
            return res.data?.toDomain()
        }
    }
    
    func logout() -> Observable<Void> {
        self.localStorage.delete(key: .userInfo)
        return self.network.request(api: LogoutAPI())
            .map { _ -> Void in () }
    }
    
    func resign() -> Observable<Void> {
        self.localStorage.delete(key: .userInfo)
        return self.network.request(api: ResignAPI())
            .map { _ -> Void in () }
    }
    
    func readToken(tokenOption: TokenOption) -> Observable<Authentication> {
        var tokenList: [String?] = []
        if tokenOption.contains(.accessToken) {
            tokenList.append(self.localStorage.read(key: .jwtAccessToken))
        }
        if tokenOption.contains(.refreshToken) {
            tokenList.append(self.localStorage.read(key: .jwtRefreshToken))
        }
        return Observable.just(Authentication(
            accessToken: tokenList[safe: 0] ?? nil,
            refreshToken: tokenList[safe: 1] ?? nil
        ))
    }
    
    func writeToken(authentication: Authentication) {
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
