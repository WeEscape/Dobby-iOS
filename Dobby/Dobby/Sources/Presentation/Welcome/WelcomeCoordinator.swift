//
//  WelcomeCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import UIKit

final class WelcomeCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator]
    
    init(childCoordinators: [Coordinator] = []) {
        self.childCoordinators = childCoordinators
    }
    
    func start(window: UIWindow?, viewController: UIViewController?) {
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
}
