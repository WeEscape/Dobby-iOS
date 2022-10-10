//
//  Coordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/1/22.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start(window: UIWindow?, viewController: UIViewController?)
    func didFinish()
    func childDidFinish(child: Coordinator)
}

class BaseCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    
    init(childCoordinators: [Coordinator] = []) {
        self.childCoordinators = childCoordinators
    }
    
    deinit {
        self.didFinish()
    }
    
    func start(window: UIWindow?, viewController: UIViewController?) { }
    
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
