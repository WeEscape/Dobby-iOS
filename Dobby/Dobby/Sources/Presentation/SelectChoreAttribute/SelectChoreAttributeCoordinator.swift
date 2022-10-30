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
    
    func didDimissViewController() {
        self.viewController = nil
        self.didFinish()
        self.parentCoordinator?.didFinish()
    }
    
    func selectChoreAttributeFactory(attribute: ChoreAttribute) -> SelectChoreAttributeView {
        switch attribute {
        case .date:
            return SelectDateAttributeView(attribute: attribute)
        case .repeatCycle, .owner, .category:
            return SelectDateAttributeView(attribute: attribute)
        case .memo:
            return SelectDateAttributeView(attribute: attribute)
        }
    }
}
