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
    }
    
    deinit {
        self.didFinish()
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
}
