//
//  MainTabBarCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/17/22.
//

import UIKit

final class MainTabBarCoordinator: BaseCoordinator {
    
    weak var parentCoordinator: Coordinator?
    
    override func start(window: UIWindow?, viewController: UIViewController?) {
        let mainTabBarController = MainTabBarController()
        mainTabBarController.modalPresentationStyle = .fullScreen
        mainTabBarController.modalTransitionStyle = .crossDissolve
        viewController?.present(mainTabBarController, animated: false)
    }
}
