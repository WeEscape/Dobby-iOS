//
//  MonthlyChoreCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit

final class MonthlyChoreCoordinator: Coordinator {

    override init(
        parentCoordinator: Coordinator? = nil,
        childCoordinators: [Coordinator] = [ChoreCardCoordinator()]
    ) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let viewModel = MonthlyChoreViewModel()
        let viewController = MonthlyChoreViewController(
            viewModel: viewModel,
            coordinator: self,
            choreCardVCFactory: self.choreCardVCFactory(date:)
        )
        self.viewController = viewController
    }
    
    func choreCardVCFactory(date: Date) -> UIViewController? {
        guard let coordinator = self.childCoordinators.filter({ child in
            return child is ChoreCardCoordinator
        }).first as? ChoreCardCoordinator
        else {
            return nil
        }
        let vc = coordinator.createViewController(
            dateList: [date],
            choreCardPeriod: .weekly
        )
        return vc
    }
}
