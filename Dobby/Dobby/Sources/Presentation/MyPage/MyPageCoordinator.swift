//
//  MyPageCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit

final class MyPageCoordinator: Coordinator {

    override init(parentCoordinator: Coordinator? = nil, childCoordinators: [Coordinator] = []) {
        super.init(parentCoordinator: parentCoordinator, childCoordinators: childCoordinators)
        let mypageVM = MyPageViewModel(
            authUseCase: AuthUseCaseImpl(
                authenticationRepository: AuthenticationRepositoryImpl(
                    network: NetworkServiceImpl.shared,
                    localStorage: UserDefaults.standard
                )
            )
        )
        let mypageVC = MyPageViewController(
            mypageCoordinator: self,
            mypageViewModel: mypageVM
        )
        self.viewController = mypageVC
    }
    
    func pushToEditProfile() {
        let editProfileCoordinator = EditProfileCoordinator(parentCoordinator: self)
        childCoordinators += [editProfileCoordinator]
        guard let editProfileVC = editProfileCoordinator.viewController,
              let navigationController = self.viewController?.navigationController
        else {return}
        navigationController.pushViewController(editProfileVC, animated: true)
    }
}
