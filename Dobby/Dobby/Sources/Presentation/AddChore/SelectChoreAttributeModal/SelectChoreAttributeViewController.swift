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

final class SelectChoreAttributeViewController: ModalViewController {
 
    // MARK: property
    var viewModel: AddChoreViewModel!
    var selectDateView: SelectDateView?
    
    // MARK: init
    convenience init(
        coordinator: SelectChoreAttributeCoordinator,
        viewModel: AddChoreViewModel,
        contentView: ModalContentView
    ) {
        self.init(coordinator: coordinator, contentView: contentView)
        self.viewModel = viewModel
        
        if let selectDateView = contentView as? SelectDateView {
            self.selectDateView = selectDateView
        }
    }
    
    override init(coordinator: ModalCoordinator, contentView: ModalContentView) {
        super.init(coordinator: coordinator, contentView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        setupUI()
        contentView.setupUI()
        contentView.showAnimation()
        bind()
    }
    
    // MARK: Rx bind
    override func bindState() {
        super.bindState()
        
        viewModel.dateBehavior
            .asDriver()
            .filterNil()
            .drive(onNext: { [weak self] dateValue in
                self?.selectDateView?.reloadView(dateValue)
            }).disposed(by: self.disposeBag)
    }
    
    override func bindAction() {
        super.bindAction()
        
        selectDateView?.datePublish
            .subscribe(onNext: { [weak self] selectedDate in
                self?.viewModel.didSelectDate(date: selectedDate)
            }).disposed(by: self.disposeBag)
        
    }
}
