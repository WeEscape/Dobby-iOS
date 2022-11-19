//
//  GroupRepositoryImpl.swift
//  Dobby
//
//  Created by yongmin lee on 11/19/22.
//

import Foundation
import RxSwift

final class GroupRepositoryImpl: GroupRepository {
    
    let network: NetworkService
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func getGroupInfo(id: String) -> Observable<Group> {
        return self.network.request(api: GroupInfoAPI(groupId: id))
            .compactMap { res in
                return res.data?.groupInfo
            }
    }
    
    func createGroup() -> Observable<Group> {
        return self.network.request(api: CreateGroupAPI())
            .compactMap { res in
                return res.data?.toDomain()
            }
    }
}
