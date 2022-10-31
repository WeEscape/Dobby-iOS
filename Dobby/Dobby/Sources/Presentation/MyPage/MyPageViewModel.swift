//
//  MyPageViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 10/31/22.
//

import Foundation
import RxSwift

final class MyPageViewModel {
    
    var disposeBag: DisposeBag = .init()
    let authUseCase: AuthUseCase
    
    init(
        authUseCase: AuthUseCase
    ) {
        self.authUseCase = authUseCase
        BeaverLog.debug("\(String(describing: self)) init")
    }
    
    deinit {
        self.disposeBag = .init()
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
}
