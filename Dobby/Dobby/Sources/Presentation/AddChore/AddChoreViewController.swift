//
//  AddChoreViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit
import SnapKit
import RxCocoa

final class AddChoreViewController: BaseViewController {
    
    // MARK: property
    let addChoreViewModel: AddChoreViewModel!
    
    // MARK: UI
    struct Metric {
        static let addBtnLeftRightInset: CGFloat = 32
        static let addBtnHeight: CGFloat = 48
        static let addBtnBottomInset: CGFloat = 25
    }
    
    private let addChoreBtn: UIButton = {
        let btn = UIButton(configuration: .filled())
        btn.tintColor = Palette.blue1
        btn.setTitle("저장하기", for: .normal)
        return btn
    }()
    
    // MARK: init
    init(
        addChoreViewModel: AddChoreViewModel?
    ) {
        self.addChoreViewModel = addChoreViewModel
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
        self.navigationItem.title = "집안일 등록"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = Palette.blue1
        
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
    }
    
    // MARK: Rx bind
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        
    }
    
    func bindAction() {
        addChoreBtn.rx.tap
            .asDriver()
            .throttle(.seconds(1), latest: false)
            .drive(onNext: { [weak self] _ in
                self?.addChoreViewModel.didTapAddBtn()
            }).disposed(by: self.disposeBag)   
    }
}