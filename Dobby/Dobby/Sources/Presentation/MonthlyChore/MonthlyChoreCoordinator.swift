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
        let viewModel = MonthlyChoreViewModel(
            choreUseCase: ChoreUseCaseImpl(
                choreRepository: ChoreRepositoryImpl(
                    network: NetworkServiceImpl.shared
                )
            ),
            userUseCase: UserUseCaseImpl(
                userRepository: UserRepositoryImpl(
                    network: NetworkServiceImpl.shared,
                    localStorage: UserDefaults.standard
                )
            ),
            groupUseCase: GroupUseCaseImpl(
                groupRepository: GroupRepositoryImpl(
                    network: NetworkServiceImpl.shared
                )
            )
        )
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
            choreCardPeriod: .monthly
        )
        return vc
    }
}
