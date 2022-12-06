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
            $0.top.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        
        scrollContainerView.addSubview(stackContainerView)
        stackContainerView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview().inset(10)
        }
    }
    
    func reloadCardViews() {
        self.stackContainerView.arrangedSubviews.forEach { [weak self] subview in
            subview.removeFromSuperview()
        }
        
        self.view.layoutIfNeeded()
        let cardViews = self.cardViewFactory()
        cardViews.forEach { [weak self] cardView in
            self?.stackContainerView.addArrangedSubview(cardView)
        }
    }
    
    func cardViewFactory() -> [ChoreCardView] {
        let dateList = viewModel.dateList
        let memberList = viewModel.memberListBehavior.value
        var ret: [ChoreCardView] = []
        
        for (dateIdx, date) in dateList.enumerated() {
            let start = dateIdx * memberList.count
            let choreList = Array(viewModel.choreListBehavior.value[start...(start + memberList.count - 1)])
            let cardView = ChoreCardView(
                date: date,
                memberList: memberList,
                choreList: choreList,
                viewModel: viewModel
            )
            ret.append(cardView)
        }
        return ret
    }
    
    // MARK: rx
    func bind() {
        bindAction()
        bindState()
    }
    
    func bindAction() {
        self.rx.viewDidAppear
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.getMemberList()
            }).disposed(by: self.disposeBag)
    }
    
    func bindState() {
        viewModel.loadingPublish
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isLoading in
                
            }).disposed(by: self.disposeBag)
        
        viewModel.memberListBehavior
            .subscribe(onNext: { [weak self] members in
                self?.viewModel.getChoreList(of: members)
            }).disposed(by: self.disposeBag)
        
        viewModel.isChoreListEmptyBehavior
            .asDriver()
            .drive(onNext: { [weak self] isEmpty in
                self?.emptyChoreImageView.isHidden = !isEmpty
                self?.scrollContainerView.isHidden = isEmpty
                if !isEmpty {
                    self?.reloadCardViews()
                }
            }).disposed(by: self.disposeBag)   
    }
}
