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
        let dummyViewController = AddTaskViewController()
        self.viewController = dummyViewController
    }
    
    override func getViewController() -> UIViewController? {
        let newViewController = AddTaskViewController()
        return newViewController
    }
}
