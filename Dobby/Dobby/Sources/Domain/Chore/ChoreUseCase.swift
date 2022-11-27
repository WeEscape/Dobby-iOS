//
//  ChoreUseCase.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import Foundation
import RxSwift

protocol ChoreUseCase {
    func postChore(chore: Chore, ownerList: [String]) -> Observable<Void>
}

final class ChoreUseCaseImpl: ChoreUseCase {
    
    let choreRepository: ChoreRepository
    
    init(choreRepository: ChoreRepository) {
        self.choreRepository = choreRepository
    }
    
    func postChore(chore: Chore, ownerList: [String]) -> Observable<Void> {
        return self.choreRepository.postChore(chore: chore, ownerList: ownerList)
    }
}
