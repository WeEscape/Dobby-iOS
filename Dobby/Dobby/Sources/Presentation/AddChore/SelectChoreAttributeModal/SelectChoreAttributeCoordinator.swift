//
//  SelectChoreAttributeCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/29/22.
//

import Foundation

final class SelectChoreAttributeCoordinator: ModalCoordinator {
    
    convenience init(
        choreAttribute: ChoreAttribute,
        viewModel: AddChoreViewModel,
        parentCoordinator: Coordinator? = nil,
        childCoordinators: [Coordinator] = []
    ) {
        self.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let viewController = SelectChoreAttributeViewController(
            coordinator: self,
            viewModel: viewModel,
            contentView: self.selectChoreAttributeFactory(attribute: choreAttribute)
        )
        viewController.modalPresentationStyle = .overFullScreen
        self.viewController = viewController
    }
    
    func selectChoreAttributeFactory(attribute: ChoreAttribute) -> ModalContentView {
        switch attribute {
        case .date:
            return SelectDateView(attribute: attribute)
        case .repeatCycle, .owner, .category:
            return SelectDateView(attribute: attribute)
        case .memo:
            return SelectDateView(attribute: attribute)
        }
    }
}
