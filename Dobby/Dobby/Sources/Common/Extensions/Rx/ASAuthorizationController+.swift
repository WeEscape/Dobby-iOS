//
//  ASAuthorizationController+.swift
//  Dobby
//
//  Created by yongmin lee on 10/4/22.
//

import RxCocoa
import RxSwift
import AuthenticationServices
import FirebaseCrashlytics


final class RxASAuthorizationControllerDelegateProxy:
    DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>,
    DelegateProxyType,
    ASAuthorizationControllerDelegate
{
    static func registerKnownImplementations() {
        self.register {
            RxASAuthorizationControllerDelegateProxy(
                parentObject: $0,
                delegateProxy: RxASAuthorizationControllerDelegateProxy.self
            )
        }
    }
    
    static func currentDelegate(for object: ASAuthorizationController) -> ASAuthorizationControllerDelegate? {
        object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: ASAuthorizationControllerDelegate?, to object: ASAuthorizationController) {
        object.delegate = delegate
    }
}

extension Reactive where Base: ASAuthorizationController {
    var delegate: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate> {
        RxASAuthorizationControllerDelegateProxy.proxy(for: base)
    }
    
    var didCompleteAuthorization: Observable<Authentication?> {
        delegate
            .methodInvoked(#selector(ASAuthorizationControllerDelegate.authorizationController(controller:didCompleteWithAuthorization:)))
            .map { parameters in
                guard let authorization = parameters[1] as? ASAuthorization,
                      let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                      let identityTokenData = credential.identityToken,
                      let authorizationCodeData = credential.authorizationCode,
                      let identityToken = String(data: identityTokenData, encoding: .utf8),
                      let authorizationCode = String(data: authorizationCodeData, encoding: .utf8)
                else {
                    Crashlytics.crashlytics().record(
                        error: CustomError(memo: "didCompleteWithAuthorization with nil")
                    )
                    return nil
                }
                
                // 첫번째 회원가입 성공이후 부터 애플로그인시에는 빈값으로 넘어옴
                let givenName = credential.fullName?.givenName ?? ""
                let userEmail = credential.email ?? ""
                
                return .init(
                    accessToken: nil,
                    refreshToken: nil,
                    identityToken: identityToken,
                    authorizeCode: authorizationCode,
                    snsUserName: givenName,
                    snsUserEmail: userEmail,
                    snsUserId: credential.user
                )
            }
    }
}
