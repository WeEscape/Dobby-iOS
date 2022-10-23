//
//  TaskUseCase.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import Foundation
import RxSwift

protocol TaskUseCase {
    func register(task: DobbyTask) -> Observable<Void>
}

final class TaskUseCaseImpl: TaskUseCase {
    func register(task: DobbyTask) -> Observable<Void> {
        return .empty()
    }
}
