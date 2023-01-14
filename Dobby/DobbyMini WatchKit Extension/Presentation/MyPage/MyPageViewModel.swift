//
//  MyPageViewModel.swift
//  DobbyMini WatchKit Extension
//
//  Created by yongmin lee on 1/14/23.
//

import Foundation
import RxSwift

class MyPageViewModel: ObservableObject {
    
    var disposeBag = DisposeBag()
    let userUseCase: UserUseCase
    
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func getMyInfo() {
        
    }
}
