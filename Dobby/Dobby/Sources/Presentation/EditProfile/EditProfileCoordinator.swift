//
//  EditProfileCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 11/1/22.
//

import UIKit

final class EditProfileCoordinator: Coordinator {
    
    override init(parentCoordinator: Coordinator? = nil, childCoordinators: [Coordinator] = []) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let viewModel = EditProfileViewModel()
        let viewController = EditProfileViewController(
            coordinator: self,
            viewModel: viewModel
        )
        self.viewController = viewController
    }
    
    func viewControllerDidFinish() {
        self.parentCoordinator?.childDidFinish(child: self)
    }
}
