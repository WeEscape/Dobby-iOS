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
    var selectRepeatCycleView: SelectRepeatCycleView?
    var selectCategotyView: SelectCategoryView?
    var selecteUserView: SelectUserView?
    
    // MARK: init
    convenience init(
        coordinator: SelectChoreAttributeCoordinator,
        viewModel: AddChoreViewModel,
        contentView: ModalContentView
    ) {
        self.init(coordinator: coordinator, contentView: contentView)
        self.viewModel = viewModel
        self.selectDateView = contentView as? SelectDateView
        self.selectRepeatCycleView = contentView as? SelectRepeatCycleView
        self.selectCategotyView = contentView as? SelectCategoryView
        self.selecteUserView = contentView as? SelectUserView
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
        guard selectDateView != nil else {return}
        contentView.setupUI()
        contentView.showAnimation()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard selectDateView == nil else {return}
        contentView.setupUI()
        contentView.showAnimation()
        bind()
    }
    
    // MARK: Rx bind
    override func bindState() {
        super.bindState()
        
        viewModel.selectedDateBehavior
            .asDriver()
            .filterNil()
            .drive(onNext: { [weak self] dateValue in
                self?.selectDateView?.reloadView(dateValue)
            }).disposed(by: self.disposeBag)
        
        viewModel.selectedRepeatCycleBehavior
            .filterNil()
            .subscribe(onNext: { [weak self] repeatCycle in
                self?.selectRepeatCycleView?.reloadView(repeatCycle)
            }).disposed(by: self.disposeBag)
        
        viewModel.selectedCategoryBehavior
            .filterNil()
            .subscribe(onNext: { [weak self] category in
                self?.selectCategotyView?.reloadView(category)
            }).disposed(by: self.disposeBag)
        
        viewModel.selectedUserBehavior
            .filterNil()
            .subscribe(onNext: { [weak self] user in
                self?.selecteUserView?.reloadView(user)
            }).disposed(by: self.disposeBag)
    }
    
    override func bindAction() {
        super.bindAction()
        
        selectDateView?.datePublish
            .subscribe(onNext: { [weak self] selectedDate in
                self?.viewModel.didSelectDate(date: selectedDate)
            }).disposed(by: self.disposeBag)
        
        selectRepeatCycleView?.repeatCyclePublish
            .subscribe(onNext: { [weak self] repeatCycle in
                self?.viewModel.didSelectRepeatCycle(repeatCycle: repeatCycle)
            }).disposed(by: self.disposeBag)
        
        selectCategotyView?.categoryPublish
            .subscribe(onNext: { [weak self] category in
                self?.viewModel.didSelectCategory(category: category)
            }).disposed(by: self.disposeBag)
        
        selecteUserView?.userPublish
            .subscribe(onNext: { [weak self] user in
                self?.viewModel.didSelectUser(user: user)
            }).disposed(by: self.disposeBag)
    }
}
