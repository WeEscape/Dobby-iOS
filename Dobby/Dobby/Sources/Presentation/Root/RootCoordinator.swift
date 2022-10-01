//
//  RootCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/1/22.
//

import UIKit

final class RootCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    
    init(
        childCoordinators: [Coordinator] = []
    ) {
        self.childCoordinators = childCoordinators
    }

    func start(window: UIWindow?, viewController: UIViewController?) {
        let splashCoordinator = SplashCoordinator()
        splashCoordinator.parentCoordinator = self
        childCoordinators += [splashCoordinator]
        splashCoordinator.start(window: window, viewController: viewController)
    }
    
    func didFinish() {
        childCoordinators.removeAll()
    }
    
    func childDidFinish(child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
