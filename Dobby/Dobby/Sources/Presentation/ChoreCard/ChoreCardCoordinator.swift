//
//  ChoreCardCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 12/3/22.
//

import UIKit

final class ChoreCardCoordinator: Coordinator {
 
    func createViewController(
        dateList: [Date], isGroupChore: Bool
    ) -> ChoreCardViewController {
        let vm = ChoreCardViewModel(dateList: dateList, isGroupChore: isGroupChore)
        let vc = ChoreCardViewController(viewModel: vm)
        return vc
    }
}
