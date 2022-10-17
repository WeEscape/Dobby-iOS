//
//  WelcomeCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import UIKit

final class WelcomeCoordinator: BaseCoordinator {
    
    weak var parentCoordinator: Coordinator?
    
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
        welcomeViewController.modalPresentationStyle = .fullScreen
        welcomeViewController.modalTransitionStyle = .coverVertical
        viewController?.present(welcomeViewController, animated: true)
    }
    
    func presentMainTab(viewContorller: UIViewController) {
        let mainTabBarCoordinator = MainTabBarCoordinator()
        mainTabBarCoordinator.parentCoordinator = self
        childCoordinators += [mainTabBarCoordinator]
        mainTabBarCoordinator.start(window: nil, viewController: viewContorller)
    }
}
