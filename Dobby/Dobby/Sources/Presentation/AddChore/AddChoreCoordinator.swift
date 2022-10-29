//
//  AddChoreCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit

final class AddChoreCoordinator: Coordinator {

    override init(parentCoordinator: Coordinator? = nil, childCoordinators: [Coordinator] = []) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let dummyViewController = AddChoreViewController(
            addChoreViewModel: nil,
            addChoreCoordinator: nil,
            choreAttributeFactory: addChoreAttributeFactory(attribute:)
        )
        self.viewController = dummyViewController
    }
    
    func createViewController() -> UIViewController? {
        let addChoreViewModel = AddChoreViewModel(
            choreUseCase: ChoreUseCaseImpl()
        )
        let newViewController = AddChoreViewController(
            addChoreViewModel: addChoreViewModel,
            addChoreCoordinator: self,
            choreAttributeFactory: addChoreAttributeFactory(attribute:)
        )
        return newViewController
    }
    
    func addChoreAttributeFactory(attribute: ChoreAttribute) -> ChoreAttributeView {
        switch attribute {
        case .date, .repeatCycle, .owner, .category:
            return ChoreAttributeView(attribute: attribute)
        case .memo:
            return ChoreMemoAttributeView(attribute: attribute)
        }
    }
    
    func showSelectChoreAttributeModal(attribute: ChoreAttribute) {

    }
}
