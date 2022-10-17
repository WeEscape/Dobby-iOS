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
import Toast_Swift

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
        self.welcomeViewModel.loginResult
            .subscribe(onNext: { [weak self] islogin in
                guard let self = self else {return}
                if islogin {
                    self.welcomeCoordinator?.presentMainTab(viewContorller: self)
                } else {
                    self.view.makeToast("로그인 실패!\n잠시후 다시 시도해주세요", duration: 3.0, position: .bottom)
                }
            }).disposed(by: self.disposeBag)
    }
    
    func bindAction() {
        self.kakaoView.rx.tapGesture()
            .when(.recognized)
            .asDriver { _ in .empty() }
            .drive(onNext: { [weak self] _ in
                self?.welcomeViewModel.login(provider: .kakao)
            })
            .disposed(by: self.disposeBag)
        
        self.appleBtn.rx.tapGesture()
            .when(.recognized)
            .asDriver { _ in .empty() }
            .drive(onNext: { [weak self] _ in
                self?.welcomeViewModel.login(provider: .apple)
            })
            .disposed(by: self.disposeBag)
    }
}
