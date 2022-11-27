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
}
