//
//  ChoreCardCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 12/3/22.
//

import UIKit

final class ChoreCardCoordinator: Coordinator {
 
    func createViewController(
        dateList: [Date],
        choreCardPeriod: ChorePeriodical
    ) -> ChoreCardViewController {
        let vm = ChoreCardViewModel(
            choreCardPeriod: choreCardPeriod,
            dateList: dateList,
            userUseCase: UserUseCaseImpl(
                userRepository: UserRepositoryImpl(
                    network: NetworkServiceImpl.shared,
                    localStorage: LocalStorageServiceImpl.shared
                )
            ),
            groupUseCase: GroupUseCaseImpl(
                groupRepository: GroupRepositoryImpl(network: NetworkServiceImpl.shared)
            ),
            choreUseCase: ChoreUseCaseImpl(
                choreRepository: ChoreRepositoryImpl(network: NetworkServiceImpl.shared)
            ),
            alarmUseCase: AlarmUseCaseImpl(
                alarmRepository: AlarmRepositoryImpl(
                    localStorage: LocalStorageServiceImpl.shared
                )
            )
        )
        let vc = ChoreCardViewController(viewModel: vm)
        return vc
    }
}
