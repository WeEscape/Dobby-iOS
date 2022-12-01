//
//  DailyChoreCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit

final class DailyChoreCoordinator: Coordinator {

    override init(parentCoordinator: Coordinator? = nil, childCoordinators: [Coordinator] = []) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let viewMode = DailyChoreViewModel(
            dailyChoreDetailFactory: self.dailyChoreDetailFactory(date:)
        )
        self.viewController = DailyChoreViewController(viewModel: viewMode)
    }
    
    func dailyChoreDetailFactory(date: Date) -> DailyChoreDetailViewController {
        let vm = DailyChoreDetailViewModel()
        let vc = DailyChoreDetailViewController(viewModel: vm)
        vc.dateLabel.text = date.toStringWithoutTime()
        return vc
    }
}
