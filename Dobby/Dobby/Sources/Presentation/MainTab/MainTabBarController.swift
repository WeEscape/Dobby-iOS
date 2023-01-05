//
//  MainTabBarController.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import UIKit
import RxSwift
import RxOptional
import RxCocoa

final class MainTabBarController: UITabBarController {
    
    // MARK: property
    var disposeBag: DisposeBag = .init()
    let mainTabViewModel: MainTabViewModel
    weak var mainTabBarCoordinator: MainTabBarCoordinator?
    let tabBarViewControllerFactory: (MainTab) -> UIViewController?
    
    // MARK: init
    init(
        mainTabViewModel: MainTabViewModel,
        mainTabBarCoordinator: MainTabBarCoordinator,
        tabBarViewControllerFactory: @escaping (MainTab) -> UIViewController?
    ) {
        self.mainTabViewModel = mainTabViewModel
        self.mainTabBarCoordinator = mainTabBarCoordinator
        self.tabBarViewControllerFactory = tabBarViewControllerFactory
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
        view.backgroundColor = .white
        tabBar.tintColor = Palette.mainThemeBlue1
        tabBar.backgroundColor = .white
        tabBar.layer.makeShadow(offSet: CGSize(width: 2, height: 2))
    }
    
    // MARK: Rx bind
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        mainTabViewModel.tabItems
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] tabBarList in
                guard let self = self else { return }
                let viewControllers = tabBarList.map { tabBarItem -> UIViewController? in
                    let viewController = self.tabBarViewControllerFactory(tabBarItem)
                    return viewController
                }.compactMap { $0 }
                self.setViewControllers(viewControllers, animated: true)
            }).disposed(by: self.disposeBag)
        
        mainTabViewModel.selectedTabIndex
            .subscribe(onNext: { [weak self] idx in
                self?.selectedIndex = idx
            }).disposed(by: self.disposeBag)
        
        mainTabViewModel.pushAddChoreTab
            .subscribe(onNext: { [weak self] _ in
                self?.mainTabBarCoordinator?.pushToAddChore()
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindAction() {
        self.rx.didSelect
            .map { [weak self] selectedVC in
                self?.viewControllers?.firstIndex(where: { selectedVC === $0 })
            }
            .filterNil()
            .subscribe(onNext: { [weak self] selectedIndex in
                self?.mainTabViewModel.didSelect(index: selectedIndex)
            })
            .disposed(by: self.disposeBag)
    }
}
