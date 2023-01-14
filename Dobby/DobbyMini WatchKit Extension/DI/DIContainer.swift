//
//  DIContainer.swift
//  DobbyMini Watch App
//
//  Created by yongmin lee on 12/22/22.
//

import Foundation
import Swinject

class DIContainer {
    
    // MARK: properties
    static let shared = DIContainer()
    private var container: Container
    
    // MARK: init
    private init() {
        self.container = Self.buildContainer()
    }
    
    // MARK: methods
    static func buildContainer() -> Container {
        let container = Container()
        
        // MARK: register Repository
        container.register(ChoreRepository.self) { _ in
            return ChoreRepositoryImpl(
                network: NetworkServiceImpl.shared
            )
        }.inObjectScope(.container)
        
        // MARK: register UseCase
        container.register(ChoreUseCase.self) { resolver in
            return ChoreUseCaseImpl(
                choreRepository: resolver.resolve(ChoreRepository.self)!
            )
        }.inObjectScope(.container)
        
        // MARK: register viewModel
        container.register(ChoreViewModel.self) { resolver in
            return ChoreViewModel(
                choreUseCase: resolver.resolve(ChoreUseCase.self)!
            )
        }.inObjectScope(.container)
        
        return container
    }
    
    func setMockContainer(_ container: Container) {
        self.container = container
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(T.self)!
    }
}
