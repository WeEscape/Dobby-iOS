//
//  ChoreUseCase.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import Foundation
import RxSwift

protocol ChoreUseCase {
    func register(chore: Chore) -> Observable<Void>
}

final class ChoreUseCaseImpl: ChoreUseCase {
    func register(chore: Chore) -> Observable<Void> {
        return .empty()

    }
}