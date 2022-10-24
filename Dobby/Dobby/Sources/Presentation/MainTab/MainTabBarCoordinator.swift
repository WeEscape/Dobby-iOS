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
            vc = self.childCoordinators[mainTab.rawValue].viewController
        case .weeklyChore:
            vc = self.childCoordinators[mainTab.rawValue].viewController
        case .addChore:
            vc = self.childCoordinators[mainTab.rawValue].viewController
        case .monthlyChore:
            vc = self.childCoordinators[mainTab.rawValue].viewController
        case .mypage:
            vc = UINavigationController(
                rootViewController: self.childCoordinators[mainTab.rawValue].viewController!
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
