//
//  SelectChoreAttributeViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/29/22.
//

import Foundation
import RxGesture
import RxViewController
import SnapKit

class SelectChoreAttributeViewController: BaseViewController {
 
    // MARK: property
    weak var selectChoreAttributeCoordinator: SelectChoreAttributeCoordinator?
    let viewModel: SelectChoreAttributeViewModel
    let selectChoreAttributeFactory: (ChoreAttribute) -> SelectChoreAttributeView?
    
    // MARK: UI
    lazy var contentView = self.selectChoreAttributeFactory(self.viewModel.choreAttribute)
    
    // MARK: init
    init(
        coordinator: SelectChoreAttributeCoordinator,
        viewModel: SelectChoreAttributeViewModel,
        factory: @escaping(ChoreAttribute) -> SelectChoreAttributeView?
    ) {
        self.selectChoreAttributeCoordinator = coordinator
        self.viewModel = viewModel
        self.selectChoreAttributeFactory = factory
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
        self.view.backgroundColor = .black.withAlphaComponent(0.66)
        
        guard let contentView = self.contentView else {return}
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.snp.bottom)
        }
        contentView.showAnimation()
    }
    
    // MARK: Rx bind
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
    }
    
    func bindAction() {
        guard let contentView = self.contentView else {return}
        
        contentView.didTapConfirm
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: false, completion: {
                    self?.selectChoreAttributeCoordinator?.didDimissViewController()
                })
            }).disposed(by: self.disposeBag)
    }
}
