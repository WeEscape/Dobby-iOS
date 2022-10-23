//
//  AddTaskViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import Foundation
import RxSwift

class AddTaskViewModel {
    
    var disposeBag: DisposeBag = .init()
    let taskUseCase: TaskUseCase
    
    init(
        taskUseCase: TaskUseCase
    ) {
        self.taskUseCase = taskUseCase
        BeaverLog.debug("\(String(describing: self)) init")
    }
    
    deinit {
        self.disposeBag = .init()
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
    func didTapAddBtn() {
        print("AddTaskViewModel didTapAddBtn ")
    }
}
