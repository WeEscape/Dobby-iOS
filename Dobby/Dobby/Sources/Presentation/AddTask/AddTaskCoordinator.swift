//
//  AddTaskCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit

final class AddTaskCoordinator: Coordinator {

    override init(parentCoordinator: Coordinator? = nil, childCoordinators: [Coordinator] = []) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let dummyViewController = AddTaskViewController(
            addTaskViewModel: nil
        )
        self.viewController = dummyViewController
    }
    
    override func getViewController() -> UIViewController? {
        let addTaskViewModel = AddTaskViewModel(
            taskUseCase: TaskUseCaseImpl()
        )
        let newViewController = AddTaskViewController(
            addTaskViewModel: addTaskViewModel
        )
        return newViewController
    }
}
