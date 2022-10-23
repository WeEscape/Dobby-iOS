//
//  MainTabBarCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/17/22.
//

import UIKit

final class MainTabBarCoordinator: Coordinator {
    
    override func start(window: UIWindow?, viewController: UIViewController?) {
        let mainTabBarController = MainTabBarController()
        self.viewController = mainTabBarController
        mainTabBarController.modalPresentationStyle = .fullScreen
        mainTabBarController.modalTransitionStyle = .crossDissolve
        viewController?.present(mainTabBarController, animated: false)
    }
    
    static func defaultChildCoordinators() ->  [Coordinator] {
        return [
            DailyTaskCoordinator(),
            WeeklyTaskCoordinator(),
            AddTaskCoordinator(),
            MonthlyTaskCoordinator(),
            MyPageCoordinator()
        ]
    }
}
