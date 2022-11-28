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
import RxViewController
import Toast_Swift
import ProgressHUD

final class AddChoreViewController: BaseViewController {
    
    // MARK: property
    let addChoreViewModel: AddChoreViewModel!
    let choreAttributeFactory: (ChoreAttribute) -> ChoreAttributeView?
    weak var addChoreCoordinator: AddChoreCoordinator?
    
    // MARK: UI
    struct Metric {
        static let addBtnLeftRightInset: CGFloat = 32
        static let addBtnHeight: CGFloat = 48
        static let addBtnBottomInset: CGFloat = 25
        static let titleFontSize: CGFloat = 18
        static let bodyFontSize: CGFloat = 16
        static let titleTextFieldHeight: CGFloat = 80
        static let bodyLeftRightInset: CGFloat = 26
    }
    
    private let addChoreBtn: UIButton = {
        let btn = UIButton(configuration: .filled())
        btn.tintColor = Palette.mainThemeBlue1
        btn.setTitle("저장하기", for: .normal)
        btn.isEnabled = false
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
        addChoreCoordinator: AddChoreCoordinator?,
        choreAttributeFactory: @escaping (ChoreAttribute) -> ChoreAttributeView?
    ) {
        self.addChoreViewModel = addChoreViewModel
        self.addChoreCoordinator = addChoreCoordinator
        self.choreAttributeFactory = choreAttributeFactory
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
            $0.height.equalTo(Metric.titleTextFieldHeight)
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
    
    func showAddChoreMessage(_ message: AddChoreViewModel.AddChoreMessage) {
        if message == .SUCCESS_ADD_CHORE {
            ProgressHUD.showSucceed(message.rawValue, interaction: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.addChoreCoordinator?.didSaveChore()
            }
        } else {
            ProgressHUD.showFailed(message.rawValue, interaction: false)
        }
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
                    if let attributeView = self.choreAttributeFactory(attribute) {
                        attributeView.delegate = self
                        self.attributeStackView.addArrangedSubview(attributeView)
                    }
                }
            }).disposed(by: self.disposeBag)
        
        addChoreViewModel.selectedDateBehavior
            .asDriver()
            .filterNil()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] selectedDate in
                guard let dateView = self?.searchChoreAttributeView(of: .startDate) else {return}
                dateView.updateTitle(title: selectedDate.toStringWithoutTime())
            }).disposed(by: self.disposeBag)
        
        addChoreViewModel.selectedRepeatCycleBehavior
            .asDriver()
            .filterNil()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] repeatCycle in
                guard let repeatCycleView = self?.searchChoreAttributeView(of: .repeatCycle)
                else {return}
                repeatCycleView.updateTitle(title: repeatCycle.description)
            }).disposed(by: self.disposeBag)
        
        addChoreViewModel.selectedCategoryBehavior
            .asDriver()
            .filterNil()
            .drive(onNext: { [weak self] category in
                guard let categoryView = self?.searchChoreAttributeView(of: .category)
                else {return}
                categoryView.updateTitle(title: category.title)
            }).disposed(by: self.disposeBag)
        
        addChoreViewModel.selectedUserBehavior
            .asDriver()
            .filterNil()
            .drive(onNext: { [weak self] user in
                guard let userView = self?.searchChoreAttributeView(of: .owner)
                else {return}
                userView.updateTitle(title: user.name)
            }).disposed(by: self.disposeBag)
        
        addChoreViewModel.addChoreMsgPublish
            .subscribe(onNext: { [weak self] message in
                self?.showAddChoreMessage(message)
            }).disposed(by: self.disposeBag)
        
        addChoreViewModel.saveBtnEnableBehavior?
            .asDriver()
            .drive(onNext: { [weak self] isEnable in
                self?.addChoreBtn.isEnabled = isEnable
            }).disposed(by: self.disposeBag)
        
        addChoreViewModel.loadingPublush
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.showLoading()
                } else {
                    self?.hideLoading()
                }
            }).disposed(by: self.disposeBag)
    }
    
    func bindAction() {
        self.rx.viewDidAppear
            .subscribe(onNext: { [weak self] _ in
                self?.addChoreViewModel.getInitialInfo()
            }).disposed(by: self.disposeBag)
        
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
        
        choreTitleTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(choreTitleTextField.rx.value)
            .subscribe(onNext: { [weak self] title in
                self?.addChoreViewModel.choreTitle = title.value
                self?.addChoreViewModel.validateSaveBtn()
            }).disposed(by: self.disposeBag)
    }
    
    func searchChoreAttributeView(of attributeType: ChoreAttribute) -> ChoreAttributeView? {
        return self.attributeStackView.arrangedSubviews.filter({ sub in
            guard let attributeView = sub as? ChoreAttributeView else {return false}
            return attributeView.attribute == attributeType
        }).first as? ChoreAttributeView
    }
}

extension AddChoreViewController: ChoreAttributeViewDelegate {
    func editingChanged(value: String?) {
        self.addChoreViewModel.choreMemo = value
    }
    
    func didTapChoreAttribute(attribute: ChoreAttribute) {
        self.addChoreCoordinator?.showSelectChoreAttributeModal(attribute: attribute)
    }
}
