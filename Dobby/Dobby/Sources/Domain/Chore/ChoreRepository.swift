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
    func getChores(userId: String, groupId: String, date: Date, periodical: ChorePeriodical) -> Observable<[Chore]>
}
