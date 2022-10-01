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
