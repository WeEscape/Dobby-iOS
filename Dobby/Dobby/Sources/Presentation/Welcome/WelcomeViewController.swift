//
//  WelcomeViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import UIKit
import AuthenticationServices
import RxCocoa
import SnapKit
import RxGesture
import RxRelay

final class WelcomeViewController: BaseViewController {
    
    let welcomeViewModel: WelcomeViewModel
    weak var welcomeCoordinator: WelcomeCoordinator?
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let kakaoView: UIView = {
        let kakao = UIView()
        kakao.backgroundColor = .yellow
        kakao.layer.cornerRadius = 10
        return kakao
    }()
    
    private let appleBtn: ASAuthorizationAppleIDButton = {
        let btn = ASAuthorizationAppleIDButton(
            authorizationButtonType: .signIn,
            authorizationButtonStyle: .black
        )
        return btn
    }()
    
    init(
        welcomeViewModel: WelcomeViewModel,
        welcomeCoordinator: WelcomeCoordinator
    ) {
        self.welcomeViewModel = welcomeViewModel
        self.welcomeCoordinator = welcomeCoordinator
        super.init(nibName: nil, bundle: nil)
        BeaverLog.debug("\(String(describing: self)) init")
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
        
        // button stackView
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(45)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(45)
            $0.height.equalTo(110)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(128)
            $0.centerX.equalToSuperview()
        }
        
        stackView.addArrangedSubview(kakaoView)
        stackView.addArrangedSubview(appleBtn)   
    }
    
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        
    }
    
    func bindAction() {
        self.kakaoView.rx.tapGesture()
            .when(.recognized)
            .asDriver { _ in .empty() }
            .drive(onNext: { [weak self] _ in
                self?.welcomeViewModel.authorize(provider: .kakao)
            })
            .disposed(by: self.disposeBag)
        
        self.appleBtn.rx.tapGesture()
            .when(.recognized)
            .asDriver { _ in .empty() }
            .drive(onNext: { [weak self] _ in
                self?.welcomeViewModel.authorize(provider: .apple)
            })
            .disposed(by: self.disposeBag)
    }
}
