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
        let contentView = self.selectProfileAttributeFactory(
            attribute: profileAttribute,
            viewModel: viewModel
        )
        let viewController = SelectProfileAttributeViewController(
            coordinator: self,
            viewModel: viewModel,
            contentView: contentView
        )
        viewController.modalPresentationStyle = .overFullScreen
        self.viewController = viewController
    }
    
    func selectProfileAttributeFactory(
        attribute: ProfileAttribute,
        viewModel: EditProfileViewModel
    ) -> ModalContentView {
        switch attribute {
        case .color:
            let colorList = viewModel.colorList
            return SelectProfileColorView(attribute: attribute, colorList: colorList)
        case .photo:
            let colorList = viewModel.colorList
            return SelectProfileColorView(attribute: attribute, colorList: colorList)
        }
    }
}
