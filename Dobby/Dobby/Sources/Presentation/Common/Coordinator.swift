//
//  Coordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/1/22.
//

import UIKit

class Coordinator {
    
    var childCoordinators: [Coordinator]
    weak var parentCoordinator: Coordinator?
    var viewController: UIViewController?
    
    init(
        parentCoordinator: Coordinator? = nil,
        childCoordinators: [Coordinator] = []
    ) {
        self.parentCoordinator = parentCoordinator
        self.childCoordinators = childCoordinators
        
        childCoordinators.forEach { child in
            child.parentCoordinator = self
        }
        BeaverLog.debug("\(String(describing: self)) init")
    }
    
    deinit {
        self.didFinish()
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
    func didFinish() {
        childCoordinators.removeAll()
    }
    
    func childDidFinish(child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
    
    func clearAllDescendant() {
        childCoordinators.forEach { child in
            child.clearAllDescendant()
        }
        childCoordinators.removeAll()
        self.viewController?.dismiss(animated: false)
        self.viewController = nil
    }
}
