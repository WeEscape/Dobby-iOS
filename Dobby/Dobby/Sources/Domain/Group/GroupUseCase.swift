//
//  GroupUseCase.swift
//  Dobby
//
//  Created by yongmin lee on 11/19/22.
//

import Foundation
import RxSwift

protocol GroupUseCase {
    func getGroupInfo(id: String) -> Observable<Group>
    func createGroup() -> Observable<Group>
    func leaveGroup(id: String) -> Observable<Void>
    func joinGroup(inviteCode: String) -> Observable<Group>
}

final class GroupUseCaseImpl: GroupUseCase {
    
    let groupRepository: GroupRepository
    
    init(groupRepository: GroupRepository) {
        self.groupRepository = groupRepository
    }
    
    func getGroupInfo(id: String) -> Observable<Group> {
        return self.groupRepository.getGroupInfo(id: id)
    }
    
    func createGroup() -> Observable<Group> {
        return self.groupRepository.createGroup()
    }
    
    func leaveGroup(id: String) -> Observable<Void> {
        return self.groupRepository.leaveGroup(id: id)
    }
    
    func joinGroup(inviteCode: String) -> Observable<Group> {
        return self.groupRepository.joinGroup(inviteCode: inviteCode)
    }
}
    
