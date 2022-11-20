//
//  CategoryUseCase.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import Foundation
import RxSwift

protocol CategoryUseCase {
    func createCategory(groupId: String, title: String) -> Observable<Category>
}

final class CategoryUseCaseImpl: CategoryUseCase {
    
    let categoryRepository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.categoryRepository = repository
    }
    
    func createCategory(groupId: String, title: String) -> Observable<Category> {
        return self.categoryRepository.createCategory(groupId: groupId, title: title)
    }
}
