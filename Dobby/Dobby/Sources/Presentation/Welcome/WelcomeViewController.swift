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
    
    // MARK: property
    let welcomeViewModel: WelcomeViewModel
    weak var welcomeCoordinator: WelcomeCoordinator?
    
    // MARK: UI
    struct Metric {
        static let kakaoLabelFontSize: CGFloat = 20
        static let kakaoLogoWidth: CGFloat = 20
        static let kakaoLogoHeight: CGFloat = 20
        static let welcomeTitleFontSize: CGFloat = 44
        static let welcomeSubTitleFontSize: CGFloat = 16
        static let stackViewLeftRightInset: CGFloat = 45
        static let stackViewBottomInset: CGFloat = 100
        static let kakaoLogoLabelInterval: CGFloat = 6
        static let dobbyLogoWidth: CGFloat = 34
        static let dobbyLogoHeight: CGFloat = 68
        static let dobbyLogoBottomMargin: CGFloat = -10
    }
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    private let kakaoView: UIView = {
        let kakao = UIView()
        kakao.backgroundColor = Palette.kakaoYellow
        kakao.layer.cornerRadius = 10
        return kakao
    }()
    
    private let kakaoLabel: UILabel = {
       let lbl = UILabel()
        lbl.font = DobbyFont.appleSDGothicNeoMedium(size: Metric.kakaoLabelFontSize).getFont
        lbl.text = "kakao로 로그인"
        lbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        lbl.textColor = Palette.textBlack1
        return lbl
    }()
    
    private let kakaologo: UIImageView = {
        let iv = UIImageView(frame: .init(
            origin: .zero,
            size: .init(width: Metric.kakaoLogoWidth, height: Metric.kakaoLogoHeight)
        ))
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
        lbl.font = DobbyFont.avenirBlack(size: Metric.welcomeTitleFontSize).getFont
        lbl.text = "DOBBY"
        lbl.textColor = Palette.textBlack1
        return lbl
    }()
    
    private let welcomeSubTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.avenirMedium(size: Metric.welcomeSubTitleFontSize).getFont
        lbl.text = "가사분담에서 해방하다"
        lbl.textColor = Palette.textBlack1
        return lbl
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.image = UIImage(named: "dobbylogo")
        return iv
    }()
    
    // MARK: init
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
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    // MARK: method
    func setupUI() {
        view.backgroundColor = .white
        
        // button stackView
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
                .inset(Metric.stackViewLeftRightInset)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
                .inset(Metric.stackViewLeftRightInset)
            $0.height.equalTo(110)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                .inset(Metric.stackViewBottomInset)
            $0.centerX.equalToSuperview()
        }
        stackView.addArrangedSubview(kakaoView)
        stackView.addArrangedSubview(appleBtn)
        
        kakaoView.addSubview(kakaoLabel)
        kakaoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
                .offset((Metric.kakaoLogoWidth + Metric.kakaoLogoLabelInterval) / 2)
            $0.centerY.equalToSuperview()
        }
        
        kakaoView.addSubview(kakaologo)
        kakaologo.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(kakaoLabel.snp.left).offset(-Metric.kakaoLogoLabelInterval)
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
            $0.width.equalTo(Metric.dobbyLogoWidth)
            $0.height.equalTo(Metric.dobbyLogoHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(welcomeSubTitle.snp.top).offset(Metric.dobbyLogoBottomMargin)
        }
    }
    
    // MARK: Rx bind
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        
        self.welcomeViewModel.loadingPublish
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.showLoading()
                } else {
                    self?.hideLoading()
                }
            }).disposed(by: self.disposeBag)
        
        self.welcomeViewModel.loginStartPublish
            .subscribe(onNext: { [weak self] provider, auth in
                self?.welcomeViewModel.login(provider: provider, auth: auth)
            }).disposed(by: self.disposeBag)
        
        self.welcomeViewModel.loginResultPublish
            .subscribe(onNext: { [weak self] islogin in
                guard let self = self else {return}
                if islogin {
                    self.welcomeCoordinator?.presentMainTab()
                } else {
                    self.view.makeToast("로그인 실패!\n잠시후 다시 시도해주세요", duration: 3.0, position: .bottom)
                }
            }).disposed(by: self.disposeBag)
        
        self.welcomeViewModel.registerStartPublish
            .subscribe(onNext: { [weak self] provider, auth in
                self?.welcomeViewModel.register(provider: provider, auth: auth)
            }).disposed(by: self.disposeBag)
    }
    
    func bindAction() {
        self.kakaoView.rx.tapGesture()
            .when(.recognized)
            .asDriver { _ in .empty() }
            .drive(onNext: { [weak self] _ in
                self?.welcomeViewModel.snsAuthorize(provider: .kakao)
            })
            .disposed(by: self.disposeBag)
        
        self.appleBtn.rx.tapGesture()
            .when(.recognized)
            .asDriver { _ in .empty() }
            .drive(onNext: { [weak self] _ in
                self?.welcomeViewModel.snsAuthorize(provider: .apple)
            })
            .disposed(by: self.disposeBag)
    }
}
