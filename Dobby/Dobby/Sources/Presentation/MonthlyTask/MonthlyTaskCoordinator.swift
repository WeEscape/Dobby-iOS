//
//  MonthlyTaskCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit

final class MonthlyTaskCoordinator: Coordinator {

    override init(parentCoordinator: Coordinator? = nil, childCoordinators: [Coordinator] = []) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        self.viewController = MonthlyTaskViewController()
    }

}
