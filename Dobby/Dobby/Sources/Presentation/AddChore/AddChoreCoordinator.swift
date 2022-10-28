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
            addChoreAttributeFactory: addChoreAttributeFactory(attribute:)
        )
        self.viewController = dummyViewController
    }
    
    override func getViewController() -> UIViewController? {
        let addChoreViewModel = AddChoreViewModel(
            choreUseCase: ChoreUseCaseImpl()
        )
        let newViewController = AddChoreViewController(
            addChoreViewModel: addChoreViewModel,
            addChoreAttributeFactory: addChoreAttributeFactory(attribute:)
        )
        return newViewController
    }
    
    func addChoreAttributeFactory(attribute: ChoreAttribute) -> AddChoreAttributeView {
        switch attribute {
        case .date:
            return AddChoreAttributeView(attribute: attribute)
        case .repeatCycle:
            return AddChoreAttributeView(attribute: attribute)
        case .owner:
            return AddChoreAttributeView(attribute: attribute)
        case .category:
            return AddChoreAttributeView(attribute: attribute)
        case .memo:
            return ChoreMemoAttributeView(attribute: attribute)
        }
    }
}
