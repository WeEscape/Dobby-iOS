//
//  ChoreRepositoryImpl.swift
//  Dobby
//
//  Created by yongmin lee on 11/27/22.
//

import Foundation
import RxSwift

final class ChoreRepositoryImpl: ChoreRepository {
    
    let network: NetworkService
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func postChore(chore: Chore, ownerList: [String]) -> Observable<Void> {
        return self.network.request(api: CreateChoreAPI(
            chore: chore,
            ownerList: ownerList
        ))
        .compactMap { _ -> Void in () }
    }
    
    func getChores(
        userId: String, groupId: String, date: Date, periodical: ChorePeriodical
    ) -> Observable<[Chore]> {
        return self.network.request(api: ChoreListAPI(
            userId: userId,
            groupId: groupId,
            date: date,
            periodical: periodical
        ))
        .compactMap { res in
            return res.data?.toDomain()
        }
    }
    
    func finishChore(chore: Chore, userId: String, isEnd: Bool) -> Observable<Void> {
        return self.network.request(api: FinishChoreAPI(
            userId: userId,
            choreId: chore.choreId,
            isEnd: isEnd
        ))
        .compactMap { _ -> Void in () }
    }
    
    func deleteChore(chore: Chore) -> Observable<Void> {
        return self.network.request(api: DeleteChoreAPI(choreId: chore.choreId))
        .compactMap { _ -> Void in () }
    }
}
