//
//  SelectChoreAttributeCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/29/22.
//

import Foundation

final class SelectChoreAttributeCoordinator: Coordinator {
    
    override init(parentCoordinator: Coordinator? = nil, childCoordinators: [Coordinator] = []) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let viewModel = SelectChoreAttributeViewModel()
        let viewController = SelectChoreAttributeViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .overFullScreen
        self.viewController = viewController
    }
}
