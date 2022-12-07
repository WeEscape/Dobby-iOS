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
        self.viewController = DailyChoreViewController(viewModel: viewMode)
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
}
