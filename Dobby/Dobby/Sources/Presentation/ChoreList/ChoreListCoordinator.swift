//
//  ChoreListCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 12/3/22.
//

import UIKit

final class ChoreListCoordinator: Coordinator {
 
    func createViewController(
        dateList: [Date], isGroupChore: Bool
    ) -> ChoreListViewController {
        let vm = ChoreListViewModel(dateList: dateList, isGroupChore: isGroupChore)
        let vc = ChoreListViewController(viewModel: vm)
        return vc
    }
}
