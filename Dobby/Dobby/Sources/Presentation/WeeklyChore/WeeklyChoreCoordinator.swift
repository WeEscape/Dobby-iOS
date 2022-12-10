//
//  WeeklyChoreCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit

final class WeeklyChoreCoordinator: Coordinator {

    override init(parentCoordinator: Coordinator? = nil, childCoordinators: [Coordinator] = []) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let viewModel = WeeklyChoreViewModel()
        let viewController = WeeklyChoreViewController(
            viewModel: viewModel,
            coordinator: self
        )
        self.viewController = viewController
    }
}
