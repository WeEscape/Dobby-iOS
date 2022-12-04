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
        childCoordinators: [Coordinator] = [ChoreListCoordinator()]
    ) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let viewMode = DailyChoreViewModel(
            choreListVCFactory: self.choreListVCFactory(date:)
        )
        self.viewController = DailyChoreViewController(viewModel: viewMode)
    }
    
    func choreListVCFactory(date: Date) -> ChoreListViewController {
        let coordinator = self.childCoordinators.filter { child in
            return child is ChoreListCoordinator
        }.first! as! ChoreListCoordinator
        let vc = coordinator.createViewController(dateList: [date], isGroupChore: false)
        return vc
    }
}
