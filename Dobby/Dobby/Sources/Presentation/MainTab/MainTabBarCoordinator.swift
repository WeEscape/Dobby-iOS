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
            DailyChoreCoordinator(),
            WeeklyChoreCoordinator(),
            AddChoreCoordinator(),
            MonthlyChoreCoordinator(),
            MyPageCoordinator()
        ]
    }
    
    func tabBarViewControllerFactory(mainTab: MainTab) -> UIViewController? {
        let vc: UIViewController?
        switch mainTab {
        case .dailyChore:
            guard let coordinator = self.childCoordinators.filter({ child in
                return child is DailyChoreCoordinator
            }).first else {return nil}
            vc = coordinator.viewController
        case .weeklyChore:
            guard let coordinator = self.childCoordinators.filter({ child in
                return child is WeeklyChoreCoordinator
            }).first else {return nil}
            vc = coordinator.viewController
        case .addChore:
            guard let coordinator = self.childCoordinators.filter({ child in
                return child is AddChoreCoordinator
            }).first else {return nil}
            vc = coordinator.viewController
        case .monthlyChore:
            guard let coordinator = self.childCoordinators.filter({ child in
                return child is MonthlyChoreCoordinator
            }).first else {return nil}
            vc = coordinator.viewController
        case .mypage:
            guard let coordinator = self.childCoordinators.filter({ child in
                return child is MyPageCoordinator
            }).first else {return nil}
            vc = UINavigationController(
                rootViewController: coordinator.viewController!
            )
        }
        vc?.tabBarItem = mainTab.getTabBarItem()
        return vc
    }
    
    func pushToAddChore() {
        guard let navigation = self.viewController as? UINavigationController else {return}
        guard let addChoreCoordinator = self.childCoordinators.filter({ child in
            return child is AddChoreCoordinator
        }).first else {return}
        guard let newAddChoreViewController = addChoreCoordinator.getViewController() else {return}
        navigation.pushViewController(newAddChoreViewController, animated: true)
    }
}
