//
//  MyPageViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit
import SnapKit

final class MyPageViewController: BaseViewController {
 
    // MARK: property
    weak var mypageCoordinator: MyPageCoordinator?
    let mypageViewModel: MyPageViewModel
    
    // MARK: init
    init(
        mypageCoordinator: MyPageCoordinator?,
        mypageViewModel: MyPageViewModel
    ) {
        self.mypageCoordinator = mypageCoordinator
        self.mypageViewModel = mypageViewModel
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
        
        self.navigationItem.title = "설정"
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        self.view.addSubview(navigationLineView)
        self.navigationLineView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        
    }
    
    func bindAction() {
        
    }
}
