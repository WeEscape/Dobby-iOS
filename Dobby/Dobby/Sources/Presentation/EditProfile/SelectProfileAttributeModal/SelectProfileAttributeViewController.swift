//
//  SelectProfileAttributeViewController.swift
//  Dobby
//
//  Created by yongmin lee on 11/2/22.
//

import Foundation
import RxGesture
import SnapKit
import RxOptional

final class SelectProfileAttributeViewController: ModalViewController {
 
    // MARK: property
    var viewModel: EditProfileViewModel!
    var selectColorView: SelectProfileColorView?
    
    // MARK: init
    convenience init(
        coordinator: SelectProfileAttributeCoordinator,
        viewModel: EditProfileViewModel,
        contentView: ModalContentView
    ) {
        self.init(coordinator: coordinator, contentView: contentView)
        self.viewModel = viewModel
        
        if let selectColorView = contentView as? SelectProfileColorView {
            self.selectColorView = selectColorView
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
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        contentView.setupUI()
        contentView.showAnimation()
    }

    // MARK: Rx bind
    override func bindState() {
        super.bindState()
        viewModel.profileColorRelay
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] profileColor in
                self?.selectColorView?.reloadView(profileColor)
            }).disposed(by: self.disposeBag)
    }
    
    override func bindAction() {
        super.bindAction()

        selectColorView?.selectColorPublish
            .subscribe(onNext: { [weak self] color in
                self?.viewModel.didSelectColor(color)
            }).disposed(by: self.disposeBag)
        
    }
}
