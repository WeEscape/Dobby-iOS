//
//  RootCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/1/22.
//

import UIKit

final class RootCoordinator: Coordinator {
    
    var window: UIWindow?

    func startSplash(window: UIWindow? = nil) {
        if self.window == nil {
            self.window = window
        }
        let newSplashCoordinator = SplashCoordinator(
            parentCoordinator: self
        )
        let splashViewController = newSplashCoordinator.viewController
        self.window?.rootViewController = splashViewController
        self.window?.makeKeyAndVisible()
        childCoordinators.forEach { child in
            child.clearAllDescendant()
        }
        childCoordinators.removeAll()
        childCoordinators += [newSplashCoordinator]
    }
}
