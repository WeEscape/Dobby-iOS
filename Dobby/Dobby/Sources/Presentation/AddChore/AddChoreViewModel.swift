//
//  AddChoreViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import Foundation
import RxSwift

class AddChoreViewModel {
    
    var disposeBag: DisposeBag = .init()
    let choreUseCase: ChoreUseCase
    
    init(
        choreUseCase: ChoreUseCase
    ) {
        self.choreUseCase = choreUseCase
        BeaverLog.debug("\(String(describing: self)) init")
    }
    
    deinit {
        self.disposeBag = .init()
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
    func didTapAddBtn() {
        print("AddChoreViewModel didTapAddBtn ")
    }
}
