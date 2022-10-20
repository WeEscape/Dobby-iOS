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
import Lottie
import SnapKit

final class SplashViewController: BaseViewController {
    
    var splashViewModel: SplashViewModel
    weak var splashCoordinator: SplashCoordinator?
    
    private let splashView: AnimationView = {
        let splash = AnimationView()
        splash.animation = Animation.named("splash")
        splash.loopMode = .loop
        splash.contentMode = .scaleAspectFit
        splash.backgroundColor = .clear
        splash.translatesAutoresizingMaskIntoConstraints = false
        splash.play()
        return splash
    }()
    
    private let dobbyLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.avenirBlack(size: 30).getFont
        lbl.text = "DOBBY"
        lbl.textColor = Palette.blue1
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    init(
        splashViewModel: SplashViewModel,
        splashCoordinator: SplashCoordinator
    ) {
        self.splashViewModel = splashViewModel
        self.splashCoordinator = splashCoordinator
        super.init(nibName: nil, bundle: nil)
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
        view.backgroundColor = .white
        
        self.view.addSubview(splashView)
        splashView.snp.makeConstraints { 
            $0.width.equalTo(300)
            $0.height.equalTo(600)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        self.view.addSubview(dobbyLabel)
        dobbyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(100)
        }
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
