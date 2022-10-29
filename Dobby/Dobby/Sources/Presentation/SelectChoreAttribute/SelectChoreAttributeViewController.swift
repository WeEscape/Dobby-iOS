//
//  SelectChoreAttributeViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/29/22.
//

import Foundation

class SelectChoreAttributeViewController: BaseViewController {
 
    let viewModel: SelectChoreAttributeViewModel
    
    // MARK: init
    init(viewModel: SelectChoreAttributeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    // MARK: method
    func setupUI() {
        self.view.backgroundColor = .green.withAlphaComponent(0.66)
    }
    
    // MARK: Rx bind
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
    }
    
    func bindAction() {
    }
    
}
