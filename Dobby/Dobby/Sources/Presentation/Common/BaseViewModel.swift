//
//  BaseViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 11/12/22.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
 
    var disposBag: DisposeBag
    let loadingPublish: PublishRelay<Bool>
    
    init() {
        self.disposBag = .init()
        self.loadingPublish = .init()
        BeaverLog.debug("\(String(describing: self)) init")
    }
    
    deinit {
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
}
