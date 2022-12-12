//
//  MyPageViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import RxOptional
import Toast_Swift

final class MyPageViewController: BaseViewController {
 
    // MARK: property
    weak var mypageCoordinator: MyPageCoordinator?
    let mypageViewModel: MyPageViewModel
    
    // MARK: UI
    private let scrollContainerView: UIScrollView = .init()
    
    private let stackContainerView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.backgroundColor = .clear
        return iv
    }()
    
    private let userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.avenirBlack(size: 36).getFont
        lbl.text = "이름"
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let groupIdLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.avenirMedium(size: 16).getFont
        lbl.text = "그룹아이디"
        lbl.textColor = Palette.textGray1
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let tutorialView = SettingItemView(title: "사용방법")
    private let profileEditView = SettingItemView(title: "프로필 수정")
    private let leaveHomeView = SettingItemView(title: "연결된 그룹 나가기")
    private let createHomeView = SettingItemView(title: "그룹 만들기")
    private let joinHomeView = SettingItemView(title: "다른 그룹 참여하기")
    private let settingView = SettingItemView(title: "도움말")
    private let logoutView = SettingItemView(title: "로그아웃")
    private let resignView = SettingItemView(
        title: "회원탈퇴",
        textColor: Palette.textRed1
    )
    
    // MARK: init
    init(
        mypageCoordinator: MyPageCoordinator?,
        mypageViewModel: MyPageViewModel
    ) {
        self.mypageCoordinator = mypageCoordinator
        self.mypageViewModel = mypageViewModel
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: method
    func setupUI() {
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "설정"
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = Palette.mainThemeBlue1
        
        let navigationLineView = self.createLineView()
        self.view.addSubview(navigationLineView)
        navigationLineView.makeLineViewConstraints(
            topEqualTo: view.safeAreaLayoutGuide.snp.top
        )
        
        self.view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.height.equalTo(54)
            $0.width.equalTo(54)
            $0.top.equalTo(navigationLineView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(groupIdLabel)
        groupIdLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(userNameLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        let nameLineView = createLineView()
        self.view.addSubview(nameLineView)
        nameLineView.makeLineViewConstraints(
            topEqualTo: groupIdLabel.snp.bottom,
            topOffset: 40
        )
        
        self.view.addSubview(scrollContainerView)
        scrollContainerView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(nameLineView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        scrollContainerView.addSubview(stackContainerView)
        stackContainerView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    func updateMyProfile(_ user: User) {
        userNameLabel.text = user.name
        guard let profileUrl = user.profileUrl else {return}
        profileImageView.setImage(urlString: profileUrl)
    }
    
    func updateGroupInviteCode(_ code: String?) {
        if let code = code {
            groupIdLabel.text = "그룹코드: " + code
        } else {
            groupIdLabel.text = "그룹 없음"
        }
    }
    
    func updateSettingItems(_ groupId: String?) {
        // 스택뷰 초기화
        stackContainerView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        self.view.layoutIfNeeded()
         
        if groupId.isNilOrEmpty() { // 그룹 없음
            stackContainerView.addArrangedSubview(createHomeView)
            stackContainerView.addArrangedSubview(joinHomeView)
        } else { // 그룹 참여중
            stackContainerView.addArrangedSubview(leaveHomeView)
        }
//        stackContainerView.addArrangedSubview(profileEditView) // TODO: 프로필수정 개발
        stackContainerView.addArrangedSubview(settingView)
        stackContainerView.addArrangedSubview(logoutView)
        stackContainerView.addArrangedSubview(resignView)
    }
    
    // MARK: Rx bind
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        mypageViewModel.alertPublish
            .subscribe(onNext: { [weak self] alertVC in
                self?.present(alertVC, animated: true)
            }).disposed(by: self.disposeBag)
        
        mypageViewModel.loadingPublish
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.showLoading()
                } else {
                    self?.hideLoading()
                }
            }).disposed(by: self.disposeBag)
        
        mypageViewModel.logoutPublish
            .subscribe(onNext: { [weak self] _ in
                self?.mypageCoordinator?.gotoSplash()
            }).disposed(by: self.disposeBag)
        
        mypageViewModel.resignPublish
            .subscribe(onNext: { [weak self] _ in
                self?.mypageCoordinator?.gotoSplash()
            }).disposed(by: self.disposeBag)
        
        mypageViewModel.myInfoBehavior
            .asDriver()
            .filterNil()
            .drive(onNext: { [weak self] user in
                self?.updateMyProfile(user)
            }).disposed(by: self.disposeBag)
        
        mypageViewModel.myGroupIdBehavior
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] groupId in
                self?.updateSettingItems(groupId)
                self?.mypageViewModel.getGroupInfo(groupId: groupId)
            }).disposed(by: self.disposeBag)
        
        mypageViewModel.inviteCodePublish
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] code in
                self?.updateGroupInviteCode(code)
            }).disposed(by: self.disposeBag)
        
        mypageViewModel.toastMessagePublish
            .debounce(.milliseconds(350), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                self?.view.makeToast(message, duration: 3.0, position: .bottom)
            }).disposed(by: self.disposeBag)
    }
    
    func bindAction() {
        self.rx.viewDidAppear
            .subscribe(onNext: { _ in
                self.mypageViewModel.getMyInfo()
            }).disposed(by: self.disposeBag)
        
        profileEditView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.mypageCoordinator?.pushToEditProfile()
            }).disposed(by: self.disposeBag)
        
        logoutView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.mypageViewModel.didTapLogout()
            }).disposed(by: self.disposeBag)
        
        resignView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.mypageViewModel.didTapResign()
            }).disposed(by: self.disposeBag)
        
        leaveHomeView.rx.tapGesture()
            .when(.recognized)
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.mypageViewModel.didTapLeaveGroup()
            }).disposed(by: self.disposeBag)
        
        createHomeView.rx.tapGesture()
            .when(.recognized)
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.mypageViewModel.createGroup()
            }).disposed(by: self.disposeBag)
        
        joinHomeView.rx.tapGesture()
            .when(.recognized)
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.mypageViewModel.didTapJoinGroup()
            }).disposed(by: self.disposeBag)
        
        settingView.rx.tapGesture()
            .when(.recognized)
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.mypageCoordinator?.pushToSetting()
            }).disposed(by: self.disposeBag)
        
        groupIdLabel.rx.longPressGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let groupText = self?.groupIdLabel.text else {return}
                self?.mypageViewModel.didLongPressGroupLabel(text: groupText)
            }).disposed(by: self.disposeBag)
        
    }
}
