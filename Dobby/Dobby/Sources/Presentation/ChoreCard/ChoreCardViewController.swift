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
import Toast_Swift

final class ChoreCardViewController: BaseViewController {
    
    // MARK: property
    let viewModel: ChoreCardViewModel
    
    // MARK: UI
    let refreshControl = UIRefreshControl()
    
    lazy var scrollContainerView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.bounces = true
        scroll.alwaysBounceVertical = true
        scroll.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        self.refreshControl.endRefreshing()
        scroll.refreshControl = self.refreshControl
        return scroll
    }()
    
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
            $0.top.equalToSuperview()
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
    
    func reloadCardViews(choreList: [[Chore]]) {
        self.stackContainerView.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        self.view.layoutIfNeeded()
        
        let dateList = viewModel.dateList
        let memberList = viewModel.memberListBehavior.value
        let choreCardPeriod = viewModel.choreCardPeriod
        let cardViews = self.cardViewFactory(
            dateList: dateList,
            memberList: memberList,
            choreList: choreList,
            choreCardPeriod: choreCardPeriod,
            viewModel: viewModel
        )
        cardViews.forEach { [weak self] cardView in
            self?.stackContainerView.addArrangedSubview(cardView)
        }
    }
    
    func cardViewFactory(
        dateList: [Date],
        memberList: [User],
        choreList: [[Chore]],
        choreCardPeriod: ChorePeriodical,
        viewModel: ChoreCardViewModel
    ) -> [ChoreCardView] {
        var ret: [ChoreCardView] = []
        for (dateIdx, date) in dateList.enumerated() {
            let start = dateIdx * memberList.count
            let choreList = Array(
                choreList[start...(start + memberList.count - 1)]
            )
            let cardView = ChoreCardView(
                choreCardPeriod: choreCardPeriod,
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
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.getMemberList()
            }).disposed(by: self.disposeBag)
    }
    
    func bindState() {
        viewModel.loadingPublish
            .bind(to: self.refreshControl.rx.isRefreshing)
            .disposed(by: self.disposeBag)
        
        viewModel.memberListBehavior
            .subscribe(onNext: { [weak self] members in
                self?.viewModel.getChoreList(of: members)
            }).disposed(by: self.disposeBag)
        
        viewModel.choreListBehavior
            .asDriver()
            .drive(onNext: { [weak self] choreList in
                if choreList.isEmpty {
                    self?.emptyChoreImageView.isHidden = false
                    self?.scrollContainerView.isHidden = true
                } else if let firstChore = choreList.first, firstChore.isEmpty {
                    self?.emptyChoreImageView.isHidden = false
                    self?.scrollContainerView.isHidden = true
                } else {
                    self?.emptyChoreImageView.isHidden = true
                    self?.scrollContainerView.isHidden = false
                    self?.reloadCardViews(choreList: choreList)
                }
            }).disposed(by: self.disposeBag)
        
        viewModel.messagePublish
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] message in
                self?.view.makeToast(message, duration: 2.0, position: .bottom)
            }).disposed(by: self.disposeBag)
            
    }
}
