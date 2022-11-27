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
        .compactMap { res -> Void in  () }
    }
}
