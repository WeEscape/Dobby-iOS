//
//  WeeklyChoreViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxOptional

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
    
    func updateTitle(with date: Date) {
        var dateStr = date.toStringWithoutTime(dateFormat: "yyyy")
        let weekOfYear = date.getWeekOfYear()
        switch weekOfYear {
        case 0:
            dateStr = date.toStringWithoutTime(dateFormat: "yyyy.MM")
            self.titleLabel.text = dateStr
        case 1:
            self.titleLabel.text = dateStr + " \(weekOfYear)st week"
        case 2:
            self.titleLabel.text = dateStr + " \(weekOfYear)nd week"
        case 3:
            self.titleLabel.text = dateStr + " \(weekOfYear)rd week"
        default:
            self.titleLabel.text = dateStr + " \(weekOfYear)th week"
        }
    }
    
    func updateWeekRange(with date: Date) {
        let datesOfSameWeek = date.getDatesOfSameWeek().sorted()
        guard let first = datesOfSameWeek.first,
              let last = datesOfSameWeek.last
        else {return}
        
        let firstTxt = "\(first.getMonth()).\(first.getDay())." + (first.getWeekday() ?? "")
        let lastTxt = "\(last.getMonth()).\(last.getDay())." + (last.getWeekday() ?? "")
        self.weekRangeText.text = firstTxt + " ~ " + lastTxt
    }
    
    func updatePageVC(_ viewControllerList: [UIViewController]) {
        guard let oldSelectedDate = viewModel.selectedDateBehavior.value.first,
              let curSelectedDate = viewModel.selectedDateBehavior.value.last
        else {return}
        let direction: UIPageViewController.NavigationDirection =
        oldSelectedDate < curSelectedDate ? .forward : .reverse
        
        if let selectedVC = viewControllerList[safe: 1] {
            DispatchQueue.main.async {
                self.pageViewController.setViewControllers(
                    [selectedVC],
                    direction: direction,
                    animated: false,
                    completion: nil
                )
            }
        }
    }
    
    // MARK: rx bind
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        viewModel.selectedDateBehavior
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .filterEmpty()
            .drive(onNext: { [weak self] selectedDates in
                guard let selectedDate = selectedDates.last else {return}
                self?.updateTitle(with: selectedDate)
                self?.updateWeekRange(with: selectedDate)
                self?.viewModel.didUpdatedSelectedDate()
            }).disposed(by: self.disposeBag)
        
        viewModel.pageVCDataSourceBehavior
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .filterEmpty()
            .drive(onNext: { [weak self] viewControllers in
                self?.updatePageVC(viewControllers)
            }).disposed(by: self.disposeBag)
    }

    func bindAction() {
        self.previousWeekBtn.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let curDate = self?.viewModel.selectedDateBehavior.value.last else {return}
                let previousWeek = curDate.getLastWeek()
                self?.viewModel.updateSelectedDate(previousWeek)
            }).disposed(by: self.disposeBag)
        
        self.nextWeekBtn.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let curDate = self?.viewModel.selectedDateBehavior.value.last else {return}
                let nextWeek = curDate.getNextWeek()
                self?.viewModel.updateSelectedDate(nextWeek)
            }).disposed(by: self.disposeBag)
        
        self.addChoreBtn.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.pushToAddChore()
            }).disposed(by: self.disposeBag)
    }
}

extension WeeklyChoreViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let dataSourceVC = viewModel.pageVCDataSourceBehavior.value
        guard let index = dataSourceVC.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = index - 1
        return dataSourceVC[safe: previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let dataSourceVC = viewModel.pageVCDataSourceBehavior.value
        guard let index = dataSourceVC.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = index + 1
        return dataSourceVC[safe: nextIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        let dataSourceVC = viewModel.pageVCDataSourceBehavior.value
        guard let currentVC = pageViewController.viewControllers?.first,
              let currentIndex = dataSourceVC.firstIndex(of: currentVC)
        else { return }
        if let date = viewModel.dateListBehavior.value[safe: currentIndex] {
            viewModel.updateSelectedDate(date)
        }
    }
}
