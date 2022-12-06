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
    func getChores(
        userId: String, groupId: String, date: Date, periodical: ChorePeriodical
    ) -> Observable<[Chore]>
}

final class ChoreUseCaseImpl: ChoreUseCase {
    
    let choreRepository: ChoreRepository
    
    init(choreRepository: ChoreRepository) {
        self.choreRepository = choreRepository
    }
    
    func postChore(chore: Chore, ownerList: [String]) -> Observable<Void> {
        return self.choreRepository.postChore(chore: chore, ownerList: ownerList)
    }
    
    func getChores(
        userId: String, groupId: String, date: Date, periodical: ChorePeriodical
    ) -> Observable<[Chore]> {
        return self.choreRepository.getChores(userId: userId, groupId: groupId, date: date, periodical: periodical)
    }
}
