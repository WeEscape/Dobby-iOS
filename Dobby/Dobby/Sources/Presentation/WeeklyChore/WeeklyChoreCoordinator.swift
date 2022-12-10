//
//  WeeklyChoreCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit

final class WeeklyChoreCoordinator: Coordinator {

    override init(
        parentCoordinator: Coordinator? = nil,
        childCoordinators: [Coordinator] = [ChoreCardCoordinator()]
    ) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let viewModel = WeeklyChoreViewModel(
            choreCardVCFactory: choreCardVCFactory(date:)
        )
        let viewController = WeeklyChoreViewController(
            viewModel: viewModel,
            coordinator: self
        )
        self.viewController = viewController
    }
    
    func pushToAddChore() {
        guard let parent = parentCoordinator as? MainTabBarCoordinator else {return}
        parent.pushToAddChore()
    }
    
    func choreCardVCFactory(date: Date) -> UIViewController {
        let coordinator = self.childCoordinators.filter { child in
            return child is ChoreCardCoordinator
        }.first! as! ChoreCardCoordinator
        let vc = coordinator.createViewController(
            dateList: [date],
            choreCardPeriod: .weekly
        )
        return vc
    }
}
