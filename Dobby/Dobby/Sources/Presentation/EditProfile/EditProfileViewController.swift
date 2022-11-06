//
//  EditProfileViewController.swift
//  Dobby
//
//  Created by yongmin lee on 11/1/22.
//

import UIKit
import SnapKit
import RxCocoa
import RxGesture
import RxOptional

final class EditProfileViewController: BaseViewController {
    
    // MARK: property
    weak var coordinator: EditProfileCoordinator?
    let viewModel: EditProfileViewModel
    
    // MARK: UI
    struct Metric {
        
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 8
        iv.image = UIImage(named: "default_profile")
        return iv
    }()
    
    private let userNameTextField: UITextField = {
        let tf = TextFieldWithPlaceholder(
            placeholder: "이름을 입력해주세요",
            fontSize: 22,
            textColor: Palette.textBlack1
        )
        tf.font = DobbyFont.avenirBlack(size: 22).getFont
        tf.returnKeyType = .done
        tf.keyboardType = .default
        tf.textAlignment = .center
        return tf
    }()
    
    private let profileEditIconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.borderWidth = 1
        iv.layer.cornerRadius = 11
        iv.layer.borderColor = UIColor.white.cgColor
        iv.image = UIImage(named: "icon_profile_edit")
        return iv
    }()
    
    private let saveBtn: UIButton = {
        let btn = UIButton(configuration: .filled())
        btn.tintColor = Palette.mainThemeBlue1
        btn.setTitle("저장하기", for: .normal)
        return btn
    }()
    
    private let editProfileColorView = EditProfileColorView(profileAttribute: .color)
    
    // MARK: init
    init(
        coordinator: EditProfileCoordinator?,
        viewModel: EditProfileViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
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
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.coordinator?.viewControllerDidFinish()
    }
    
    // MARK: method
    func setupUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "프로필 수정"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.topViewController?.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = Palette.mainThemeBlue1
        
        self.view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(60)
        }
        
        self.profileImageView.addSubview(profileEditIconView)
        profileEditIconView.snp.makeConstraints {
            $0.width.equalTo(22)
            $0.height.equalTo(22)
            $0.right.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().offset(4)
        }
        
        self.view.addSubview(userNameTextField)
        userNameTextField.text = "스테파니"
        userNameTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(55)
            $0.right.equalToSuperview().inset(55)
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
        
        let lineView = self.createLineView()
        self.view.addSubview(lineView)
        lineView.makeLineViewConstraints(
            leftInset: 55,
            rightInset: 55,
            topEqualTo: userNameTextField.snp.bottom,
            topOffset: 10
        )
        
        self.view.addSubview(editProfileColorView)
        editProfileColorView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
            $0.top.equalTo(lineView.snp.bottom).offset(20)
        }
        
        self.view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints {
            $0.left.equalToSuperview().inset(32)
            $0.right.equalToSuperview().inset(32)
            $0.height.equalTo(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(25)
        }
    }
    
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        viewModel.profileColorRelay
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] profileColor in
                self?.editProfileColorView.setSelectedColor(profileColor)
            }).disposed(by: self.disposeBag)
    }
    
    func bindAction() {
        profileImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                print("Debug : show profile photo edit")
            }).disposed(by: self.disposeBag)
        
        editProfileColorView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.showSelectProfileAttributeModal(attribute: .color)
            }).disposed(by: self.disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
