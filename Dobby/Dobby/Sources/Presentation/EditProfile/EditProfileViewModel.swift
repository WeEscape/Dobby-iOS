//
//  EditProfileViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 11/1/22.
//

import Foundation
import RxSwift

final class EditProfileViewModel {
    
    var disposeBag: DisposeBag = .init()
    
    init() {
        BeaverLog.debug("\(String(describing: self)) init")
    }
    
    deinit {
        self.disposeBag = .init()
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
}
