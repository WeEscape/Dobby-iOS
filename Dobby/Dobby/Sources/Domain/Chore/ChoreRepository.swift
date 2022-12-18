//
//  ChoreRepository.swift
//  Dobby
//
//  Created by yongmin lee on 11/27/22.
//

import Foundation
import RxSwift

protocol ChoreRepository {
    func postChore(chore: Chore, ownerList: [String]) -> Observable<Void>
    func finishChore(chore: Chore, userId: String, isEnd: Bool) -> Observable<Void>
    func getChores(
        userId: String, groupId: String, date: Date, periodical: ChorePeriodical
    ) -> Observable<[Chore]>
    func deleteChore(chore: Chore) -> Observable<Void>
}
