//
//  SelectChoreAttributeCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/29/22.
//

import Foundation

final class SelectChoreAttributeCoordinator: Coordinator {
    
    convenience init(
        choreAttribute: ChoreAttribute,
        parentCoordinator: Coordinator? = nil,
        childCoordinators: [Coordinator] = []
    ) {
        self.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let viewModel = SelectChoreAttributeViewModel(choreAttribute: choreAttribute)
        let viewController = SelectChoreAttributeViewController(
            coordinator: self,
            viewModel: viewModel
        )
        viewController.modalPresentationStyle = .overFullScreen
        self.viewController = viewController
    }
    
    func didDimissViewController() {
        self.viewController = nil
        self.didFinish()
        self.parentCoordinator?.didFinish()
    }
}
