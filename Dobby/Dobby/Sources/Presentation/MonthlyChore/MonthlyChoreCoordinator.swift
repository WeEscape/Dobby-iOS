//
//  MonthlyChoreCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit

final class MonthlyChoreCoordinator: Coordinator {

    override init(parentCoordinator: Coordinator? = nil, childCoordinators: [Coordinator] = []) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let viewModel = MonthlyChoreViewModel()
        let viewController = MonthlyChoreViewController(
            viewModel: viewModel,
            coordinator: self
        )
        self.viewController = viewController
    }
}
