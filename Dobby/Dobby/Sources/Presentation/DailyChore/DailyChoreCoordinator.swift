//
//  DailyChoreCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit

final class DailyChoreCoordinator: Coordinator {

    override init(
        parentCoordinator: Coordinator? = nil,
        childCoordinators: [Coordinator] = [ChoreCardCoordinator()]
    ) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let viewMode = DailyChoreViewModel(
            choreCardVCFactory: self.choreCardVCFactory(date:)
        )
        let viewController = DailyChoreViewController(viewModel: viewMode)
        viewController.coordinator = self
        self.viewController = viewController
    }
    
    func choreCardVCFactory(date: Date) -> ChoreCardViewController {
        let coordinator = self.childCoordinators.filter { child in
            return child is ChoreCardCoordinator
        }.first! as! ChoreCardCoordinator
        let vc = coordinator.createViewController(
            dateList: [date],
            choreCardPeriod: .daily
        )
        return vc
    }
    
    func pushToAddChore() {
        guard let parent = parentCoordinator as? MainTabBarCoordinator else {return}
        parent.pushToAddChore()
    }
}
