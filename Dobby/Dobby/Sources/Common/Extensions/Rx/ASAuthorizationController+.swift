//
//  ASAuthorizationController+.swift
//  Dobby
//
//  Created by yongmin lee on 10/4/22.
//

import RxCocoa
import RxSwift
import AuthenticationServices


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
                else { return nil }
                return .init(
                    accessToken: nil,
                    refreshToken: nil,
                    identityToken: identityToken,
                    authorizeCode: authorizationCode
                )
            }
    }
}
