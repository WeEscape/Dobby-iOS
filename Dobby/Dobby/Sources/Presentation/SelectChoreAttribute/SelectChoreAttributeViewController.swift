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
import RxOptional

final class SelectChoreAttributeViewController: BaseViewController {
 
    // MARK: property
    weak var selectChoreAttributeCoordinator: SelectChoreAttributeCoordinator?
    let viewModel: AddChoreViewModel
    
    // MARK: UI
    let contentView: SelectChoreAttributeView
    
    // MARK: init
    init(
        coordinator: SelectChoreAttributeCoordinator,
        viewModel: AddChoreViewModel,
        contentView: SelectChoreAttributeView
    ) {
        self.selectChoreAttributeCoordinator = coordinator
        self.viewModel = viewModel
        self.contentView = contentView
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
        viewModel.dateBehavior
            .asDriver()
            .filterNil()
            .drive(onNext: { [weak self] dateValue in
                self?.contentView.setState(dateValue)
            }).disposed(by: self.disposeBag)
    }
    
    func bindAction() {
        contentView.didTapConfirm
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: false, completion: {
                    self?.selectChoreAttributeCoordinator?.didDimissViewController()
                })
            }).disposed(by: self.disposeBag)
        
        contentView.datePublish
            .subscribe(onNext: { [weak self] selectedDate in
                self?.viewModel.didSelectDate(date: selectedDate)
            }).disposed(by: self.disposeBag)
        
    }
}
