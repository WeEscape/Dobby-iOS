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
            viewModel: viewModel,
            factory: self.selectChoreAttributeFactory(attribute:)
        )
        viewController.modalPresentationStyle = .overFullScreen
        self.viewController = viewController
    }
    
    func didDimissViewController() {
        self.viewController = nil
        self.didFinish()
        self.parentCoordinator?.didFinish()
    }
    
    func selectChoreAttributeFactory(attribute: ChoreAttribute) -> SelectChoreAttributeView? {
        guard let viewController = self.viewController as? SelectChoreAttributeViewController
        else {return nil}
        let viewModel = viewController.viewModel
        
        switch attribute {
        case .date:
            return SelectDateAttributeView(viewModel: viewModel)
        case .repeatCycle, .owner, .category:
            return SelectDateAttributeView(viewModel: viewModel)
        case .memo:
            return SelectDateAttributeView(viewModel: viewModel)
        }
    }
}
