//
//  SettingViewController.swift
//  Dobby
//
//  Created by yongmin lee on 11/28/22.
//

import UIKit
import SnapKit
import RxSwift
import RxGesture

final class SettingViewController: BaseViewController {
    
    // MARK: property
    weak var coordinator: MyPageCoordinator?
    
    // MARK: UI
    private let scrollContainerView: UIScrollView = .init()
    
    private let stackContainerView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    
    private let termsView = SettingItemView(title: "이용약관")
    private let privatePolicyView = SettingItemView(title: "개인정보 처리방침")
       
    // MARK: init
    init(coordinator: MyPageCoordinator?) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindAction()
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "도움말"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.topViewController?.extendedLayoutIncludesOpaqueBars = true
        
        let navigationLineView = self.createLineView()
        self.view.addSubview(navigationLineView)
        navigationLineView.makeLineViewConstraints(
            topEqualTo: view.safeAreaLayoutGuide.snp.top
        )
        
        self.view.addSubview(scrollContainerView)
        scrollContainerView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(navigationLineView.snp.bottom)
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
        
        stackContainerView.addArrangedSubview(termsView)
        stackContainerView.addArrangedSubview(privatePolicyView)
    }
    
    func bindAction() {
        termsView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.pushToPolicy(policyType: .terms)
            }).disposed(by: self.disposeBag)
        
        privatePolicyView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.pushToPolicy(policyType: .privatePolicy)
            }).disposed(by: self.disposeBag)
    }
}
