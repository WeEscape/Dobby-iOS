//
//  MainTabBarCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/17/22.
//

import UIKit

final class MainTabBarCoordinator: Coordinator {
    
    override init(
        parentCoordinator: Coordinator? = nil,
        childCoordinators: [Coordinator] = [
            DailyChoreCoordinator(),
            WeeklyChoreCoordinator(),
            AddChoreCoordinator(),
            MonthlyChoreCoordinator(),
            MyPageCoordinator()
        ]
    ) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let mainTabViewModel = MainTabViewModel()
        let mainTabBarController = UINavigationController(
            rootViewController: MainTabBarController(
                mainTabViewModel: mainTabViewModel,
                mainTabBarCoordinator: self,
                tabBarViewControllerFactory: self.tabBarViewControllerFactory(mainTab:)
            )
        )
        mainTabBarController.modalPresentationStyle = .fullScreen
        mainTabBarController.modalTransitionStyle = .crossDissolve
        self.viewController = mainTabBarController
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
        let addChoreCoordinatorList = self.childCoordinators.filter({ child in
            return child is AddChoreCoordinator
        })
        guard let navigation = self.viewController as? UINavigationController,
              let addChoreCoordinator = addChoreCoordinatorList.first as? AddChoreCoordinator,
              let newAddChoreViewController = addChoreCoordinator.createViewController()
        else {return}
        navigation.pushViewController(newAddChoreViewController, animated: true)
    }
}
