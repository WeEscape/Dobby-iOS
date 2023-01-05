//
//  MonthlyChoreViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit
import SnapKit
import FSCalendar
import RxSwift
import RxGesture
import RxViewController

final class MonthlyChoreViewController: BaseViewController {
    
    // MARK: Properties
    struct Metric {
        static let calendarViewHeight: CGFloat = 360
        static let containerHeaderViewHeight: CGFloat = 40
    }
    weak var coordinator: MonthlyChoreCoordinator?
    let viewModel: MonthlyChoreViewModel
    let choreCardVCFactory: (Date) -> UIViewController?
    weak var choreCardVC: UIViewController?
    
    // MARK: UI
    private lazy var calendarView: FSCalendar = {
        let calendarView = FSCalendar()
        calendarView.scope = .month
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.headerTitleFont = DobbyFont.avenirBlack(size: 20).getFont
        calendarView.appearance.headerTitleColor = Palette.textBlack1
        calendarView.appearance.headerDateFormat = "YYYY년 MM월"
        calendarView.appearance.weekdayTextColor = Palette.textBlack1
        calendarView.appearance.weekdayFont = DobbyFont.avenirMedium(size: 15).getFont
        calendarView.placeholderType = .none
        calendarView.headerHeight = 60
        calendarView.allowsMultipleSelection = false
        calendarView.swipeToChooseGesture.isEnabled = false
        calendarView.appearance.eventDefaultColor = Palette.mainThemeBlue1
        calendarView.appearance.eventSelectionColor = Palette.mainThemeBlue1
        calendarView.appearance.todayColor = Palette.mainThemeBlue1.withAlphaComponent(0.4)
        calendarView.appearance.selectionColor = Palette.mainThemeBlue1
        calendarView.dataSource = self
        calendarView.delegate = self
        return calendarView
    }()
    
    private let choreContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Palette.pageBackground
        return view
    }()
    
    private let containerHatView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let containerHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let choreCardContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: initialize
    init(
        viewModel: MonthlyChoreViewModel,
        coordinator: MonthlyChoreCoordinator,
        choreCardVCFactory: @escaping(Date) -> UIViewController?
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.choreCardVCFactory = choreCardVCFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: view lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    // MARK: methods
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(Metric.calendarViewHeight)
        }
        
        view.addSubview(choreContainerView)
        choreContainerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                .inset(Metric.calendarViewHeight)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    
        choreContainerView.addSubview(containerHatView)
        containerHatView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(6)
        }
        
        choreContainerView.addSubview(containerHeaderView)
        containerHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(Metric.containerHeaderViewHeight)
        }
        
        choreContainerView.addSubview(choreCardContainerView)
        choreCardContainerView.snp.makeConstraints {
            $0.top.equalTo(containerHeaderView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func extendChoreView(isExtend: Bool) {
        self.choreContainerView.snp.updateConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                .inset(isExtend ? 0 : Metric.calendarViewHeight)
        }
        self.choreContainerView.layer.cornerRadius = isExtend ? 30 : 0
        if isExtend {
            choreContainerView.layer.makeShadow(offSet: .zero)
        } else {
            choreContainerView.layer.shadowColor = UIColor.clear.cgColor
        }
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.8,
            options: .curveEaseInOut,
            animations: {
                self.view.layoutIfNeeded()
            })
    }
    
    func setupChoreCardVC(date: Date) {
        choreCardContainerView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        self.view.layoutIfNeeded()
        self.choreCardVC?.removeFromParent()
        
        guard let viewController = self.choreCardVCFactory(date) else {return}
        self.choreCardVC = viewController
        self.addChild(viewController)
        
        choreCardContainerView.addSubview(viewController.view)
        viewController.view.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: Rx bind
    func bind() {
        bindAction()
        bindState()
    }
    
    func bindAction() {
        self.rx.viewDidAppear
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.viewModel.fetchMonthlyChoreList(self.calendarView.currentPage)
            }).disposed(by: self.disposeBag)
        
        containerHeaderView.rx.swipeGesture(.up)
            .when(.recognized)
            .asDriver(onErrorJustReturn: .init())
            .drive(onNext: { [weak self] _ in
                self?.extendChoreView(isExtend: true)
            }).disposed(by: self.disposeBag)
        
        containerHeaderView.rx.swipeGesture(.down)
            .when(.recognized)
            .asDriver(onErrorJustReturn: .init())
            .drive(onNext: { [weak self] _ in
                self?.extendChoreView(isExtend: false)
            }).disposed(by: self.disposeBag)
    }
    
    func bindState() {
        viewModel.calendarReloadPublish
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.calendarView.reloadData()
            }).disposed(by: self.disposeBag)
        
        viewModel.selectedDateBehavior
            .asDriver()
            .drive(onNext: { [weak self] selectedDate in
                self?.calendarView.select(selectedDate)
                self?.setupChoreCardVC(date: selectedDate)
            }).disposed(by: self.disposeBag)
    }
}

extension MonthlyChoreViewController: FSCalendarDataSource, FSCalendarDelegateAppearance {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
            .getFirstDayOfSameMonth()
            .calculateDiffDate(diff: -1)!
            .getFirstDayOfSameMonth()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
            .getFirstDayOfSameMonth()
            .getNextMonth()
            .getNextMonth()
            .calculateDiffDate(diff: -1)!
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return viewModel.checkEventExist(for: date) ? 1 : 0
    }
    
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        self.viewModel.didSelectDate(date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.viewModel.fetchMonthlyChoreList(calendar.currentPage)
    }
    
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleDefaultColorFor date: Date
    ) -> UIColor? {
        let currentCalendar = Calendar.current
        let dateComponent = currentCalendar
            .dateComponents([.year, .month, .day, .weekday], from: date)
        guard let weekday = dateComponent.weekday else {return .black}
        if weekday == 1 {
            return .red
        } else if weekday == 7 {
            return .blue
        } else {
            return .black
        }
    }
}
