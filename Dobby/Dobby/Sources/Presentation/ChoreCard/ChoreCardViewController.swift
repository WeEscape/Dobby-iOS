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
import RxOptional
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
        scroll.contentInset = .init(top: 20, left: 0, bottom: 100, right: 0)
        self.refreshControl.endRefreshing()
        scroll.refreshControl = self.refreshControl
        return scroll
    }()
    
    private let stackContainerView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 20
        return stack
    }()
    
    private let emptyChoreImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.image = UIImage(named: "emptyChore")
        iv.isHidden = true
        return iv
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.startAnimating()
        indicator.isHidden = false
        return indicator
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
        
        self.view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func reloadCardViews(choreArr: [Chore]) {
        self.stackContainerView.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        self.view.layoutIfNeeded()
        
        let memberList = viewModel.memberListBehavior.value
        let choreCardPeriod = viewModel.choreCardPeriod
        let choreDict = Dictionary(grouping: choreArr, by: {$0.executeAt})
        let keyList = choreDict.keys.sorted()
        keyList.forEach { key in
            if let choreList = choreDict[key],
               let keyDate = key.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
                let cardView = ChoreCardView(
                    choreCardPeriod: choreCardPeriod,
                    date: keyDate,
                    memberList: memberList,
                    choreArr: choreList,
                    viewModel: viewModel
                )
                self.stackContainerView.addArrangedSubview(cardView)
            }
        }
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
                self?.viewModel.refreshChoreList()
            }).disposed(by: self.disposeBag)
        
        self.rx.viewDidDisappear
            .subscribe(onNext: { [unowned self] _ in
                if !self.emptyChoreImageView.isHidden {
                    self.emptyChoreImageView.isHidden = true
                    self.indicatorView.isHidden = false
                }
            }).disposed(by: self.disposeBag)
    }
    
    func bindState() {
        viewModel.loadingPublish
            .bind(to: self.refreshControl.rx.isRefreshing)
            .disposed(by: self.disposeBag)
        
        viewModel.memberListBehavior
            .filterEmpty()
            .subscribe(onNext: { [weak self] members in
                self?.viewModel.getChoreList(of: members)
            }).disposed(by: self.disposeBag)
        
        viewModel.choreArrPublish
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] choreArr in
                self?.indicatorView.isHidden = true
                self?.emptyChoreImageView.isHidden = !choreArr.isEmpty
                self?.scrollContainerView.isHidden = choreArr.isEmpty
                if choreArr.isNotEmpty {
                    self?.reloadCardViews(choreArr: choreArr)
                }
            }).disposed(by: self.disposeBag)
        
        viewModel.messagePublish
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] message in
                self?.view.makeToast(message, duration: 2.0, position: .bottom)
            }).disposed(by: self.disposeBag)
            
    }
}
