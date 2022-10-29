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
        self.window = window
        let splashCoordinator = SplashCoordinator(
            parentCoordinator: self
        )
        childCoordinators += [splashCoordinator]
        let splashViewController = splashCoordinator.viewController
        self.window?.rootViewController = splashViewController
        self.window?.makeKeyAndVisible()
    }
}
