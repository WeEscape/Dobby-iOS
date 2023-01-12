//
//  SplashCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/1/22.
//

import UIKit

final class SplashCoordinator: Coordinator {
    
    override init(parentCoordinator: Coordinator? = nil, childCoordinators: [Coordinator] = []) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let splashViewModel = SplashViewModel(
            authUseCase: AuthUseCaseImpl(
                authenticationRepository: AuthenticationRepositoryImpl(
                    network: NetworkServiceImpl.shared,
                    localStorage: LocalStorageServiceImpl.shared
                )
            )
        )
        let splashViewController = SplashViewController(
            splashViewModel: splashViewModel,
            splashCoordinator: self
        )
        self.viewController = splashViewController
    }
    
    func presentMainTab() {
        let mainTabBarCoordinator = MainTabBarCoordinator(
            parentCoordinator: self
        )
        childCoordinators += [mainTabBarCoordinator]
        guard let mainTabVC = mainTabBarCoordinator.viewController else {return}
        self.viewController?.present(mainTabVC, animated: true)
    }
    
    func presentWelcome() {
        let welcomeCoordinator = WelcomeCoordinator(
            parentCoordinator: self
        )
        childCoordinators += [welcomeCoordinator]
        guard let welcomVC = welcomeCoordinator.viewController else {return}
        self.viewController?.present(welcomVC, animated: true)
    }
}
