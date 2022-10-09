//
//  RootCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/1/22.
//

import UIKit

final class RootCoordinator: BaseCoordinator {
    
    var window: UIWindow?
    
    override func start(window: UIWindow?, viewController: UIViewController? = nil) {
        self.window = window
        self.startSplash()
    }
    
    func startSplash() {
        let splashCoordinator = SplashCoordinator()
        splashCoordinator.parentCoordinator = self
        childCoordinators += [splashCoordinator]
        splashCoordinator.start(window: self.window, viewController: nil)
    }
}
