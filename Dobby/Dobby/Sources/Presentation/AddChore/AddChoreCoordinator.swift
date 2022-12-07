//
//  AddChoreCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit

final class AddChoreCoordinator: Coordinator {

    var initialVC: AddChoreViewController?
    
    override init(parentCoordinator: Coordinator? = nil, childCoordinators: [Coordinator] = []) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let dummyViewController = AddChoreViewController(
            addChoreViewModel: nil,
            addChoreCoordinator: nil,
            choreAttributeFactory: addChoreAttributeFactory(attribute:)
        )
        self.initialVC = dummyViewController
        self.viewController = dummyViewController
    }
    
    func createViewController() -> UIViewController? {
        let addChoreViewModel = AddChoreViewModel(
            choreUseCase: ChoreUseCaseImpl(
                choreRepository: ChoreRepositoryImpl(
                    network: NetworkServiceImpl.shared
                )
            ),
            userUseCase: UserUseCaseImpl(
                userRepository: UserRepositoryImpl(
                    network: NetworkServiceImpl.shared,
                    localStorage: UserDefaults.standard
                )
            ),
            groupUseCase: GroupUseCaseImpl(
                groupRepository: GroupRepositoryImpl(
                    network: NetworkServiceImpl.shared
                )
            ),
            categoryUseCase: CategoryUseCaseImpl(
                repository: CategoryRepositoryImpl(
                    network: NetworkServiceImpl.shared
                )
            )
        )
        let newViewController = AddChoreViewController(
            addChoreViewModel: addChoreViewModel,
            addChoreCoordinator: self,
            choreAttributeFactory: addChoreAttributeFactory(attribute:)
        )
        self.viewController = newViewController
        return newViewController
    }
    
    func addChoreAttributeFactory(attribute: ChoreAttribute) -> ChoreAttributeView {
        switch attribute {
        case .startDate, .endDate, .repeatCycle, .owner, .category:
            return ChoreAttributeView(attribute: attribute)
        case .memo:
            return ChoreMemoView(attribute: attribute)
        }
    }
    
    func showSelectChoreAttributeModal(attribute: ChoreAttribute) {
        guard let addChoreVC = self.viewController as? AddChoreViewController,
              let addChoreVM = addChoreVC.addChoreViewModel
        else {return}
        let selectAttributeCoordinator = SelectChoreAttributeCoordinator(
            choreAttribute: attribute,
            viewModel: addChoreVM,
            parentCoordinator: self
        )
        childCoordinators += [selectAttributeCoordinator]
        guard let selectVC = selectAttributeCoordinator.viewController else {return}
        self.viewController?.present(selectVC, animated: false)
    }
    
    func finishAddChore() {
        self.viewController?.navigationController?.popViewController(animated: true)
        self.viewController = self.initialVC
    }
}
