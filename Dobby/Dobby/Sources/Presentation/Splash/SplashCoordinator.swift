//
//  SplashCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/1/22.
//

import UIKit

final class SplashCoordinator: BaseCoordinator {
    
    weak var parentCoordinator: Coordinator?
    
     override func start(window: UIWindow?, viewController: UIViewController?) {
        let splashViewModel = SplashViewModel(
            authUseCase: AuthUseCaseImpl(
                authenticationRepository: AuthenticationRepositoryImpl(
                    network: NetworkServiceImpl.shared,
                    localStorage: UserDefaults.standard
                )
            )
        )
        let splashViewController = SplashViewController(
            splashViewModel: splashViewModel,
            splashCoordinator: self
        )
        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()
    }
    
    func presentMainTab(viewContorller: UIViewController) {
        let mainTabBarCoordinator = MainTabBarCoordinator()
        mainTabBarCoordinator.parentCoordinator = self
        childCoordinators += [mainTabBarCoordinator]
        mainTabBarCoordinator.start(window: nil, viewController: viewContorller)
    }
    
    func presentWelcome(viewContorller: UIViewController) {
        let welcomeCoordinator = WelcomeCoordinator()
        welcomeCoordinator.parentCoordinator = self
        childCoordinators += [welcomeCoordinator]
        welcomeCoordinator.start(window: nil, viewController: viewContorller)
    }
}
