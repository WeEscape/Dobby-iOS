//
//  WelcomeCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import UIKit

final class WelcomeCoordinator: Coordinator {
    
    override func start(window: UIWindow?, viewController: UIViewController?) {
        let welcomeViewModel = WelcomeViewModel(
            authUseCase: AuthUseCaseImpl(
                authenticationRepository: AuthenticationRepositoryImpl(
                    network: NetworkServiceImpl.shared,
                    localStorage: UserDefaults.standard
                )
            )
        )
        let welcomeViewController = WelcomeViewController(
            welcomeViewModel: welcomeViewModel,
            welcomeCoordinator: self
        )
        self.viewController = welcomeViewController
        welcomeViewController.modalPresentationStyle = .fullScreen
        welcomeViewController.modalTransitionStyle = .coverVertical
        viewController?.present(welcomeViewController, animated: true)
    }
    
    func presentMainTab() {
        let mainTabBarCoordinator = MainTabBarCoordinator(
            parentCoordinator: self,
            childCoordinators: MainTabBarCoordinator.defaultChildCoordinators()
        )
        childCoordinators += [mainTabBarCoordinator]
        mainTabBarCoordinator.start(window: nil, viewController: self.viewController)
    }
}
