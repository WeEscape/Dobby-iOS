//
//  WeeklyChoreViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit
import SnapKit

final class WeeklyChoreViewController: BaseViewController {
    
    // MARK: properties
    weak var coordinator: WeeklyChoreCoordinator?
    let viewModel: WeeklyChoreViewModel
    
    // MARK: UI
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.avenirBlack(size: 24).getFont
        lbl.textColor = .black
        lbl.text = "주간 집안일"
        return lbl
    }()
    
    private let weekRangeText: UITextView = {
        let txtView = UITextView()
        txtView.isScrollEnabled = false
        txtView.isUserInteractionEnabled = false
        txtView.textAlignment = .center
        txtView.font = DobbyFont.avenirBlack(size: 16).getFont
        txtView.textColor = Palette.textGray1
        txtView.text = ""
        return txtView
    }()
    
    private let previousWeekBtn: UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "chevron.left")?
            .withTintColor(Palette.textGray1, renderingMode: .alwaysOriginal)
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleToFill
        btn.backgroundColor = .white
        return btn
    }()
    
    private let nextWeekBtn: UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "chevron.right")?
            .withTintColor(Palette.textGray1, renderingMode: .alwaysOriginal)
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleToFill
        btn.backgroundColor = .white
        return btn
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        vc.view.backgroundColor = Palette.pageBackground
        vc.delegate = self
        vc.dataSource = self
        return vc
    }()
    
    private let addChoreBtn: UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "plus")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleToFill
        btn.backgroundColor = Palette.mainThemeBlue1
        btn.layer.cornerRadius = 30
        btn.layer.makeShadow()
        return btn
    }()
    
    // MARK: initialize
    init(viewModel: WeeklyChoreViewModel, coordinator: WeeklyChoreCoordinator) {
        self.coordinator = coordinator
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
        self.view.backgroundColor = .white
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        self.view.addSubview(weekRangeText)
        weekRangeText.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.height.equalTo(50)
        }
        
        self.view.addSubview(previousWeekBtn)
        previousWeekBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview()
            $0.height.equalTo(100)
            $0.width.equalTo(60)
        }
        
        self.view.addSubview(nextWeekBtn)
        nextWeekBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.right.equalToSuperview()
            $0.height.equalTo(100)
            $0.width.equalTo(60)
        }
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(weekRangeText.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        pageViewController.didMove(toParent: self)
        
        view.addSubview(addChoreBtn)
        addChoreBtn.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(60)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    // MARK: rx bind
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        
    }
    
    func bindAction() {
        
    }
}


extension WeeklyChoreViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        
        return nil
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {

        return nil
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {

    }
}
