//
//  EditProfileViewController.swift
//  Dobby
//
//  Created by yongmin lee on 11/1/22.
//

import UIKit
import SnapKit

final class EditProfileViewController: BaseViewController {
    
    // MARK: property
    weak var coordinator: EditProfileCoordinator?
    let viewModel: EditProfileViewModel
    
    // MARK: UI
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
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
        
        self.view.addSubview(userNameTextField)
        userNameTextField.text = "스테파티"
        userNameTextField.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
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
    }
    
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        
    }
    
    func bindAction() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
