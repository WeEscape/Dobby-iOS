//
//  GroupRepository.swift
//  Dobby
//
//  Created by yongmin lee on 11/19/22.
//

import Foundation
import RxSwift

protocol GroupRepository {
    func getGroupInfo(id: String) -> Observable<Group>
    func createGroup() -> Observable<Group>
    func leaveGroup(id: String) -> Observable<Void>
    func joinGroup(inviteCode: String) -> Observable<Group>
}
