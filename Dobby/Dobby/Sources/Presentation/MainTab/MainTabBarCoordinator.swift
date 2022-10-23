//
//  MainTabBarCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/17/22.
//

import UIKit

final class MainTabBarCoordinator: Coordinator {
    
    override func start(window: UIWindow?, viewController: UIViewController?) {
        let mainTabViewModel = MainTabViewModel()
        let mainTabBarController = UINavigationController(
            rootViewController: MainTabBarController(
                mainTabViewModel: mainTabViewModel,
                mainTabBarCoordinator: self,
                tabBarViewControllerFactory: self.tabBarViewControllerFactory(mainTab:)
            )
        )
        self.viewController = mainTabBarController
        mainTabBarController.modalPresentationStyle = .fullScreen
        mainTabBarController.modalTransitionStyle = .crossDissolve
        viewController?.present(mainTabBarController, animated: true)
    }
    
    static func defaultChildCoordinators() -> [Coordinator] {
        return [
            DailyTaskCoordinator(),
            WeeklyTaskCoordinator(),
            AddTaskCoordinator(),
            MonthlyTaskCoordinator(),
            MyPageCoordinator()
        ]
    }
    
    func tabBarViewControllerFactory(mainTab: MainTab) -> UIViewController? {
        let vc: UIViewController?
        switch mainTab {
        case .dailyTask:
            vc = self.childCoordinators[mainTab.rawValue].getViewController()
        case .weeklyTask:
            vc = self.childCoordinators[mainTab.rawValue].getViewController()
        case .addTask:
            vc = self.childCoordinators[mainTab.rawValue].getViewController()
        case .monthlyTask:
            vc = self.childCoordinators[mainTab.rawValue].getViewController()
        case .mypage:
            vc = UINavigationController(
                rootViewController: self.childCoordinators[mainTab.rawValue].getViewController()!
            )
        }
        vc?.tabBarItem = mainTab.getTabBarItem()
        return vc
    }
    
    func pushToAddTask() {
        guard let navigation = self.viewController as? UINavigationController else {return}
        guard let addTaskCoordinator = self.childCoordinators.filter ({ child in
            return child is AddTaskCoordinator
        }).first else {return}
        guard let newAddTaskViewController = addTaskCoordinator.getViewController() else {return}
        navigation.pushViewController(newAddTaskViewController,animated: true)
    }
}
