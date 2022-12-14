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
    func finishChore(chore: Chore, userId: String, isEnd: Bool) -> Observable<Void>
    func getChores(
        userId: String, groupId: String, date: Date, periodical: ChorePeriodical
    ) -> Observable<[Chore]>
    func deleteChore(chore: Chore) -> Observable<Void>
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
        return self.choreRepository.getChores(
            userId: userId,
            groupId: groupId,
            date: date,
            periodical: periodical
        )
    }
    
    func finishChore(chore: Chore, userId: String, isEnd: Bool) -> Observable<Void> {
        return self.choreRepository.finishChore(chore: chore, userId: userId, isEnd: isEnd)
    }
    
    func deleteChore(chore: Chore) -> Observable<Void> {
        return self.choreRepository.deleteChore(chore: chore)
    }
}
