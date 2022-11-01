//
//  MyPageViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit
import SnapKit
import RxCocoa
import RxGesture

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
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "default_profile")
        return iv
    }()
    
    private let userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.avenirBlack(size: 36).getFont
        lbl.text = "스테파니"
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let tutorialView = SettingItemView(title: "사용방법")
    private let profileEditView = SettingItemView(title: "프로필 수정")
    private let leaveHomeView = SettingItemView(title: "연결된 집안일 나가기")
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
    
    // MARK: method
    func setupUI() {
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "설정"
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        
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
        
        let nameLineView = createLineView()
        self.view.addSubview(nameLineView)
        nameLineView.makeLineViewConstraints(
            topEqualTo: userNameLabel.snp.bottom,
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
        
//        stackContainerView.addArrangedSubview(tutorialView)
        stackContainerView.addArrangedSubview(leaveHomeView)
        stackContainerView.addArrangedSubview(profileEditView)
        stackContainerView.addArrangedSubview(logoutView)
        stackContainerView.addArrangedSubview(resignView)
    }
    
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        
    }
    
    func bindAction() {
        leaveHomeView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                print("Debug : leaveHomeView.rx.tapGesture() ")
            }).disposed(by: self.disposeBag)
        
        profileEditView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.mypageCoordinator?.pushToEditProfile()
            }).disposed(by: self.disposeBag)
        
        logoutView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                print("Debug : logoutView.rx.tapGesture() ")
            }).disposed(by: self.disposeBag)
        
        resignView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                print("Debug : resignView.rx.tapGesture() ")
            }).disposed(by: self.disposeBag)
    }
}
