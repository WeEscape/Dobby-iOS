//
//  SplashCoordinator.swift
//  Dobby
//
//  Created by yongmin lee on 10/1/22.
//

import UIKit

final class SplashCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator]
    
    init(parentCoordinator: Coordinator? = nil, childCoordinators: [Coordinator] = []) {
        self.parentCoordinator = parentCoordinator
        self.childCoordinators = childCoordinators
    }
    
    func start(window: UIWindow?, viewController: UIViewController?) {
        <#code#>
    }
    
    func didFinish() {
        <#code#>
    }
    
    func childDidFinish(child: Coordinator) {
        <#code#>
    }
    
    
}
