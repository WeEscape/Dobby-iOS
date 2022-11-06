//
//  WelcomeCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import UIKit

final class WelcomeCoordinator: Coordinator {
    
    override init(parentCoordinator: Coordinator? = nil, childCoordinators: [Coordinator] = []) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let welcomeViewModel = WelcomeViewModel(
            authUseCase: AuthUseCaseImpl(
                authenticationRepository: AuthenticationRepositoryImpl(
                    network: NetworkServiceImpl.shared,
                    localTokenStorage: UserDefaults.standard
                )
            )
        )
        let welcomeViewController = WelcomeViewController(
            welcomeViewModel: welcomeViewModel,
            welcomeCoordinator: self
        )
        welcomeViewController.modalPresentationStyle = .fullScreen
        welcomeViewController.modalTransitionStyle = .coverVertical
        self.viewController = welcomeViewController
    }
    
    func presentMainTab() {
        let mainTabBarCoordinator = MainTabBarCoordinator(
            parentCoordinator: self,
            childCoordinators: MainTabBarCoordinator.defaultChildCoordinators()
        )
        childCoordinators += [mainTabBarCoordinator]
        guard let mainTabVC = mainTabBarCoordinator.viewController else {return}
        self.viewController?.present(mainTabVC, animated: true)
    }
}
