//
//  SelectChoreAttributeViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/29/22.
//

import Foundation
import RxGesture

class SelectChoreAttributeViewController: BaseViewController {
 
    weak var selectChoreAttributeCoordinator: SelectChoreAttributeCoordinator?
    let viewModel: SelectChoreAttributeViewModel
    
    // MARK: init
    init(
        coordinator: SelectChoreAttributeCoordinator,
        viewModel: SelectChoreAttributeViewModel
    ) {
        self.selectChoreAttributeCoordinator = coordinator
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
        setupBackgroundTap()
    }
    
    // MARK: method
    func setupUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.66)
    }
    
    func setupBackgroundTap() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapBackgroundView)
        )
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func didTapBackgroundView() {
        self.dismiss(animated: true) {
            self.selectChoreAttributeCoordinator?.didDimissViewController()
        }
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
