//
//  AddChoreViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit
import SnapKit
import RxCocoa
import RxOptional

final class AddChoreViewController: BaseViewController {
    
    // MARK: property
    let addChoreViewModel: AddChoreViewModel!
    let addChoreAttributeFactory: (ChoreAttribute) -> AddChoreAttributeView?
    
    // MARK: UI
    struct Metric {
        static let addBtnLeftRightInset: CGFloat = 32
        static let addBtnHeight: CGFloat = 48
        static let addBtnBottomInset: CGFloat = 25
        static let titleFontSize: CGFloat = 18
        static let bodyFontSize: CGFloat = 16
        static let textFieldHeight: CGFloat = 80
        static let bodyLeftRightInset: CGFloat = 26
    }
    
    private let addChoreBtn: UIButton = {
        let btn = UIButton(configuration: .filled())
        btn.tintColor = Palette.mainThemeBlue1
        btn.setTitle("저장하기", for: .normal)
        return btn
    }()
    
    private let choreTitleTextField: UITextField = {
        let tf = TextFieldWithPlaceholder(
            placeholder: "집안일을 입력하세요",
            fontSize: Metric.titleFontSize,
            textColor: Palette.textBlack1
        )
        tf.returnKeyType = .done
        tf.keyboardType = .default
        tf.autocorrectionType = .no
        return tf
    }()
    
    private let attributeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 0
        return stack
    }()
    
    // MARK: init
    init(
        addChoreViewModel: AddChoreViewModel?,
        addChoreAttributeFactory: @escaping (ChoreAttribute) -> AddChoreAttributeView?
    ) {
        self.addChoreViewModel = addChoreViewModel
        self.addChoreAttributeFactory = addChoreAttributeFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard addChoreViewModel != nil else {return}
        setupUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        choreTitleTextField.becomeFirstResponder()
    }
    
    // MARK: method
    func setupUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "집안일 등록"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = Palette.mainThemeBlue1
        
        self.view.addSubview(addChoreBtn)
        addChoreBtn.snp.makeConstraints {
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
                .inset(Metric.addBtnLeftRightInset)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
                .inset(Metric.addBtnLeftRightInset)
            $0.height.equalTo(Metric.addBtnHeight)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                .inset(Metric.addBtnBottomInset)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(choreTitleTextField)
        choreTitleTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(Metric.bodyLeftRightInset)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(Metric.bodyLeftRightInset)
            $0.height.equalTo(Metric.textFieldHeight)
        }
        
        self.view.addSubview(attributeStackView)
        attributeStackView.snp.makeConstraints {
            $0.top.equalTo(choreTitleTextField.snp.bottom)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(Metric.bodyLeftRightInset)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(Metric.bodyLeftRightInset)
            $0.bottom.equalTo(addChoreBtn.snp.top).inset(-Metric.addBtnBottomInset)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Rx bind
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        addChoreViewModel.attributeItems
            .asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] attributeList in
                guard let self = self else { return }
                attributeList.forEach { attribute in
                    if let attributeView = self.addChoreAttributeFactory(attribute) {
                        self.attributeStackView.addArrangedSubview(attributeView)
                    }
                }
            }).disposed(by: self.disposeBag)
    }
    
    func bindAction() {
        addChoreBtn.rx.tap
            .asDriver()
            .throttle(.seconds(1), latest: false)
            .drive(onNext: { [weak self] _ in
                self?.addChoreViewModel.didTapAddBtn()
            }).disposed(by: self.disposeBag)
        
        choreTitleTextField.rx.controlEvent(.editingDidEndOnExit)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            }).disposed(by: self.disposeBag)
    }
}
