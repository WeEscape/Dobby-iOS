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

final class MonthlyChoreViewController: BaseViewController {
    
    // MARK: Properties
    struct Metric {
        static let calendarViewHeight: CGFloat = 350
        static let containerHeaderViewHeight: CGFloat = 50
    }
    
    // MARK: UI
    private lazy var calendarView: FSCalendar = {
        let calendarView = FSCalendar()
        calendarView.scope = .month
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.eventDefaultColor = Palette.mainThemeBlue1
        calendarView.appearance.headerTitleFont = DobbyFont.avenirBlack(size: 20).getFont
        calendarView.appearance.headerDateFormat = "YYYY년 MM월"
        calendarView.headerHeight = 60
        calendarView.allowsMultipleSelection = false
        calendarView.swipeToChooseGesture.isEnabled = false
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
        view.backgroundColor = .yellow
        return view
    }()
    
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
        
        calendarView.select(Date().getFirstDayOfSameMonth())
    }
    
    func extendChoreView(isExtend: Bool) {
        self.choreContainerView.snp.updateConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                .inset(isExtend ? 0 : Metric.calendarViewHeight)
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
    
    // MARK: Rx bind
    func bind() {
        bindAction()
        bindState()
    }
    
    func bindAction() {
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
        
    }
}

extension MonthlyChoreViewController: FSCalendarDataSource, FSCalendarDelegateAppearance {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date().getLastMonth().getFirstDayOfSameMonth()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date().getNextMonth().getLastDayOfSameMonth()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        print(date.toStringWithoutTime() + " selected")
    }
}
