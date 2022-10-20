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
        return stack
    }()
    
    private let kakaoView: UIView = {
        let kakao = UIView()
        kakao.backgroundColor = Palette.yellow1
        kakao.layer.cornerRadius = 10
        return kakao
    }()
    
    private let kakaoLabel: UILabel = {
       let lbl = UILabel()
        lbl.font = DobbyFont.appleSDGothicNeoMedium(size: 20).getFont
        lbl.text = "kakao로 로그인"
        lbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        lbl.textColor = Palette.black1
        return lbl
    }()
    
    private let kakaologo: UIImageView = {
        let iv = UIImageView(frame: .init(origin: .zero, size: .init(width: 20, height: 20)))
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.image = UIImage(named: "kakaologo")
        return iv
    }()
    
    private let appleBtn: ASAuthorizationAppleIDButton = {
        let btn = ASAuthorizationAppleIDButton(
            authorizationButtonType: .signIn,
            authorizationButtonStyle: .black
        )
        return btn
    }()
    
    private let welcomeTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.avenirBlack(size: 44).getFont
        lbl.text = "DOBBY"
        lbl.textColor = Palette.black1
        return lbl
    }()
    
    private let welcomeSubTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.avenirMedium(size: 16).getFont
        lbl.text = "가사분담에서 해방하다"
        lbl.textColor = Palette.black1
        return lbl
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.image = UIImage(named: "dobbylogo")
        return iv
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(100)
            $0.centerX.equalToSuperview()
        }
        stackView.addArrangedSubview(kakaoView)
        stackView.addArrangedSubview(appleBtn)
        
        kakaoView.addSubview(kakaoLabel)
        kakaoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(13)
            $0.centerY.equalToSuperview()
        }
        
        kakaoView.addSubview(kakaologo)
        kakaologo.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(kakaoLabel.snp.left).offset(-6)
        }
        
        self.view.addSubview(welcomeSubTitle)
        welcomeSubTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(welcomeTitle)
        welcomeTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(welcomeSubTitle.snp.bottom)
        }
        
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.width.equalTo(34)
            $0.height.equalTo(68)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(welcomeSubTitle.snp.top).offset(-10)
        }
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
