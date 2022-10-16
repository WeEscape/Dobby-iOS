//
//  SplashViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/1/22.
//

import UIKit
import RxSwift
import RxRelay
import RxViewController

final class SplashViewController: BaseViewController {
    
    var splashViewModel: SplashViewModel
    weak var splashCoordinator: SplashCoordinator?
    
    init(
        splashViewModel: SplashViewModel,
        splashCoordinator: SplashCoordinator
    ) {
        self.splashViewModel = splashViewModel
        self.splashCoordinator = splashCoordinator
        super.init(nibName: nil, bundle: nil)
        BeaverLog.verbose("\(String(describing: self)) init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    func setupUI() {
        view.backgroundColor = .green
    }
    
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        self.splashViewModel.isSignIn
            .subscribe(onNext: { [weak self] result in
                guard let self = self else {return}
                if result {
                    self.splashCoordinator?.presentMainTab(viewContorller: self)
                } else {
                    self.splashCoordinator?.presentWelcome(viewContorller: self)
                }
            }).disposed(by: self.disposeBag)
    }
    
    func bindAction() {
     
        self.rx.viewDidAppear
            .subscribe { _ in
                let splashDuration: DispatchTimeInterval = .seconds(2)
                DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) { [weak self] in
                    self?.splashViewModel.loadAccessToken()
                }
            }.disposed(by: self.disposeBag)
    }
    
}
