//
//  CategoryRepositoryImpl.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import Foundation
import Foundation
import RxSwift

final class CategoryRepositoryImpl: CategoryRepository {
    
    let network: NetworkService
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func createCategory(groupId: String, title: String) -> Observable<Category> {
        return self.network.request(api: CreateCategoryAPI(groupId: groupId, title: title))
            .compactMap { res in
                return res.data?.toDomain()
            }
    }
}
