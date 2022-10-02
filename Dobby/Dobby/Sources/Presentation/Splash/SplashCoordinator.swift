//
//  SplashCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/1/22.
//

import UIKit

final class SplashCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator]
    
    init(parentCoordinator: Coordinator? = nil, childCoordinators: [Coordinator] = []) {
        self.parentCoordinator = parentCoordinator
        self.childCoordinators = childCoordinators
    }
    
    func start(window: UIWindow?, viewController: UIViewController?) {
        let splashViewModel = SplashViewModel(
            authUseCase: AuthUseCaseImpl(
                authenticationRepository: AuthenticationRepositoryImpl(
                    network: NetworkServiceImpl(),
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
    
    func didFinish() {
        //
    }
    
    func childDidFinish(child: Coordinator) {
        //
    }
    
    func presentMainTab() {
        print("debug : presentMainTab  ")
    }
    
    func presentWelcome() {
        print("debug : presentWelcome  ")
    }
}
