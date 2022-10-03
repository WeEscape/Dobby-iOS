//
//  WelcomeViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation
import RxSwift
import RxRelay

class WelcomeViewModel {
    
    var disposBag: DisposeBag = .init()
    let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    func authorize(provider: AuthenticationProvider) {
        self.authUseCase.authorize(provider: provider )
            .subscribe(
                onNext: { [weak self] auth in
                    // 1. write token
                    self?.authUseCase.writeToken(authentication: auth)
                    // 2. 완료 이벤트 방출
                    
                }, onError: { _ in
                    //
                }
            ).disposed(by: self.disposBag)
    }
    
    func appleAuthorize() {
        print("debug : appleAuthorize ")
    }
}
