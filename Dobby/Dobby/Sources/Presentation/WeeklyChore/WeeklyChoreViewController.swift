//
//  WeeklyChoreViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit

final class WeeklyChoreViewController: BaseViewController {
    
    // MARK: properties
    weak var coordinator: WeeklyChoreCoordinator?
    let viewModel: WeeklyChoreViewModel
    
    // MARK: UI

    
    // MARK: initialize
    init(viewModel: WeeklyChoreViewModel, coordinator: WeeklyChoreCoordinator) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    // MARK: methods
    func setupUI() {
        self.view.backgroundColor = .white
    }
    
    // MARK: rx bind
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        
    }
    
    func bindAction() {
        
    }
    
}
