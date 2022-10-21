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
    
    // MARK: property
    var splashViewModel: SplashViewModel
    weak var splashCoordinator: SplashCoordinator?
    
    // MARK: UI
    struct Metric {
        static let dobbyLabelFontSize: CGFloat = 30
        static let splashImageWidth: CGFloat = 300
        static let splashImageHeight: CGFloat = 600
        static let dobbyLabelBottomInset: CGFloat = 100
    }
    
    private let splashView: AnimationView = {
        let splash = AnimationView()
        splash.animation = Animation.named("splash")
        splash.loopMode = .loop
        splash.contentMode = .scaleAspectFit
        splash.backgroundColor = .clear
        splash.play()
        return splash
    }()
    
    private let dobbyLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.avenirBlack(size: Metric.dobbyLabelFontSize).getFont
        lbl.text = "DOBBY"
        lbl.textColor = Palette.blue1
        return lbl
    }()
    
    // MARK: init
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
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    // MARK: method
    func setupUI() {
        view.backgroundColor = .white
        
        self.view.addSubview(splashView)
        splashView.snp.makeConstraints { 
            $0.width.equalTo(Metric.splashImageWidth)
            $0.height.equalTo(Metric.splashImageHeight)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        self.view.addSubview(dobbyLabel)
        dobbyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                .inset(Metric.dobbyLabelBottomInset)
        }
    }
    
    // MARK: Rx bind
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
