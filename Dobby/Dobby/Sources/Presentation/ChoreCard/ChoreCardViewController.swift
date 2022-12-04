//
//  ChoreCardViewController.swift
//  Dobby
//
//  Created by yongmin lee on 11/13/22.
//

import UIKit
import SnapKit
import RxViewController
import RxCocoa

final class ChoreCardViewController: BaseViewController {
    
    // MARK: property
    let viewModel: ChoreCardViewModel
    
    // MARK: UI
    private let scrollContainerView: UIScrollView = .init()
    
    private let stackContainerView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    
    private let emptyChoreImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.image = UIImage(named: "emptyChore")
        return iv
    }()
    
    // MARK: init
    init(viewModel: ChoreCardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: methods
    func setupUI() {
        
        self.view.addSubview(emptyChoreImageView)
        emptyChoreImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(160)
            $0.height.equalTo(100)
        }
        
        self.view.addSubview(scrollContainerView)
        scrollContainerView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
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
    
    func bind() {
        bindAction()
        bindState()
    }
    
    func bindAction() {
        
    }
    
    func bindState() {
        viewModel.choreListPerDatBehavior
            .subscribe(onNext: { [weak self] choreListPerDate in
                self?.emptyChoreImageView.isHidden = !choreListPerDate.isEmpty
                // TODO: card view factory
            }).disposed(by: self.disposeBag)
    }
}
