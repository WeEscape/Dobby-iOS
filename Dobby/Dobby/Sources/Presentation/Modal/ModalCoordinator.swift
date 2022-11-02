//
//  ModalCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/29/22.
//

import Foundation

class ModalCoordinator: Coordinator {
    func didDimissViewController() {
        self.viewController = nil
        self.didFinish()
        self.parentCoordinator?.didFinish()
    }
}
