//
//  SelectProfileAttributeCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 11/2/22.
//

import Foundation

final class SelectProfileAttributeCoordinator: ModalCoordinator {
    
    convenience init(
        profileAttribute: ProfileAttribute,
        viewModel: EditProfileViewModel,
        parentCoordinator: Coordinator? = nil,
        childCoordinators: [Coordinator] = []
    ) {
        self.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let viewController = SelectProfileAttributeViewController(
            coordinator: self,
            viewModel: viewModel,
            contentView: self.selectProfileAttributeFactory(attribute: profileAttribute)
        )
        viewController.modalPresentationStyle = .overFullScreen
        self.viewController = viewController
    }
    
    func selectProfileAttributeFactory(attribute: ProfileAttribute) -> ModalContentView {
        switch attribute {
        case .color:
            return SelectProfileColorView(attribute: attribute)
        case .photo:
            return SelectProfileColorView(attribute: attribute)
        }
    }
}
