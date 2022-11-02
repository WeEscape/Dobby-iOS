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
    var selectDateAttributeView: SelectDateAttributeView?
    
    // MARK: init
    convenience init(
        coordinator: SelectChoreAttributeCoordinator,
        viewModel: AddChoreViewModel,
        contentView: ModalContentView
    ) {
        self.init(coordinator: coordinator, contentView: contentView)
        self.viewModel = viewModel
        
        if let selectDateAttributeView = contentView as? SelectDateAttributeView {
            self.selectDateAttributeView = selectDateAttributeView
        }
    }
    
    override init(coordinator: ModalCoordinator, contentView: ModalContentView) {
        super.init(coordinator: coordinator, contentView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Rx bind
    override func bindState() {
        super.bindState()
        
        viewModel.dateBehavior
            .asDriver()
            .filterNil()
            .drive(onNext: { [weak self] dateValue in
                self?.selectDateAttributeView?.setState(dateValue)
            }).disposed(by: self.disposeBag)
    }
    
    override func bindAction() {
        super.bindAction()
        
        selectDateAttributeView?.datePublish
            .subscribe(onNext: { [weak self] selectedDate in
                self?.viewModel.didSelectDate(date: selectedDate)
            }).disposed(by: self.disposeBag)
        
    }
}
