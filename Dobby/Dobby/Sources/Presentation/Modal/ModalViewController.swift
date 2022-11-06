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

class ModalViewController: BaseViewController {
 
    // MARK: property
    weak var coordinator: ModalCoordinator?
    
    // MARK: UI
    let contentView: ModalContentView
    
    // MARK: init
    init(
        coordinator: ModalCoordinator,
        contentView: ModalContentView
    ) {
        self.coordinator = coordinator
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
    
    // MARK: Rx bind
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {}
    
    func bindAction() {
        contentView.didTapConfirm
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: false, completion: {
                    self?.coordinator?.didDimissViewController()
                })
            }).disposed(by: self.disposeBag)
    }
}
