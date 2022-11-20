//
//  CategoryRepository.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import Foundation
import RxSwift

protocol CategoryRepository {
    func createCategory(groupId: String, title: String) -> Observable<Category>
}
