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
}
    
