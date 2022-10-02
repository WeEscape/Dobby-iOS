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
}
