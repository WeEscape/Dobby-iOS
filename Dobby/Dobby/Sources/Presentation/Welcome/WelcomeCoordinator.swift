//
//  WelcomeCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import UIKit

final class WelcomeCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator]
    
    init(childCoordinators: [Coordinator] = []) {
        self.childCoordinators = childCoordinators
    }
    
    func start(window: UIWindow?, viewController: UIViewController?) {
        print("debug :  WelcomeCoordinator start")
    }
    
    func didFinish() {
        
    }
    
    func childDidFinish(child: Coordinator) {
        
    }
    
    
}
