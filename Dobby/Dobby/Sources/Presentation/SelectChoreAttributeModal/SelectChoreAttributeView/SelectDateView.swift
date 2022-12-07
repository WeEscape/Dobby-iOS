//
//  SelectDateView.swift
//  Dobby
//
//  Created by yongmin lee on 10/29/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SelectDateView: ModalContentView {
    
    // MARK: property
    var attribute: ChoreAttribute!
    let datePublish = PublishRelay<(Date, ChoreAttribute)>.init()
    weak var viewModel: AddChoreViewModel!
    
    // MARK: init
    override init() {
        super.init()
    }
    
    convenience init(
        attribute: ChoreAttribute,
        viewModel: AddChoreViewModel
    ) {
        self.init()
        self.attribute = attribute
        self.viewModel = viewModel
        self.headerTitle.text = self.attribute.description
        setupDatePickerRange()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
    // MARK: UI
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.locale = .current
        datePicker.timeZone = .current
        return datePicker
    }()
    
    override func setupUI() {
        super.setupUI()
        
        bodyView.addArrangedSubview(datePicker)
        bodyView.snp.updateConstraints { 
            $0.bottom.equalToSuperview().inset(-Metric.headerViewHeight-datePicker.frame.height)
        }
    }
    
    override func showAnimation() {
        UIView.animate(withDuration: 0.1, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.bodyView.snp.updateConstraints {
                $0.bottom.equalToSuperview()
            }
            UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseOut) {
                self.layoutIfNeeded()
            }
        })
    }
    
    override func bindAction() {
        super.bindAction()
        
        datePicker.rx.date
            .subscribe(onNext: { [weak self] date in
                guard let selectedDate = date.description.toDate(),
                      let attribute = self?.attribute,
                      let self = self
                else {return}
                self.datePublish.accept((selectedDate, attribute))
            }).disposed(by: self.disposeBag)
    }
    
    override func reloadView(_ value: Any?) {
        guard let date = value as? Date else {return}
        self.datePicker.date = date
    }
    
    func setupDatePickerRange() {
        if attribute == .startDate {
            datePicker.minimumDate = Date().getLastMonth()
            datePicker.maximumDate = Date().getNextMonth()
        } else if attribute == .endDate{
            viewModel.selectedStartDateBehavior
                .subscribe(onNext: { [weak self] startDate in
                    self?.datePicker.minimumDate = startDate
                    self?.datePicker.maximumDate = startDate?.calculateDiffDate(diff: 365)
                }).disposed(by: self.disposeBag)
        }
    }
}
