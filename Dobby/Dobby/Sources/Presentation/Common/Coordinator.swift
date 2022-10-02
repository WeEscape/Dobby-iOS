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

extension Coordinator {
    func didFinish() {
        childCoordinators.removeAll()
    }
    
    func childDidFinish(child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
