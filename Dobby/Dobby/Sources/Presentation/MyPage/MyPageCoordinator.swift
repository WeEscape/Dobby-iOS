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
                    localStorage: LocalStorageServiceImpl.shared
                )
            ),
            userUserCase: UserUseCaseImpl(
                userRepository: UserRepositoryImpl(
                    network: NetworkServiceImpl.shared,
                    localStorage: LocalStorageServiceImpl.shared
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
            ),
            alarmUseCase: AlarmUseCaseImpl(
                alarmRepository: AlarmRepositoryImpl(
                    localStorage: LocalStorageServiceImpl.shared
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
    
    func pushToHelpDesk() {
        let vc = HelpDeskViewController(coordinator: self)
        guard let navigationController = self.viewController?.navigationController
        else {return}
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushToPolicy(policyType: PolicyType) {
        let vc = PolicyViewController(policyType: policyType)
        guard let navigationController = self.viewController?.navigationController
        else {return}
        navigationController.pushViewController(vc, animated: true)
    }
    
    func gotoSplash() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.rootCoordinator?.startSplash()
    }
}
