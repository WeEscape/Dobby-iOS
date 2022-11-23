//
//  SelectDateView.swift
//  Dobby
//
//  Created by yongmin lee on 10/29/22.
//

import UIKit
import SnapKit
import RxCocoa

final class SelectDateView: ModalContentView {
    
    // MARK: property
    var attribute: ChoreAttribute!
    let datePublish = PublishRelay<Date>.init()
    
    // MARK: init
    override init() {
        super.init()
    }
    
    convenience init(attribute: ChoreAttribute) {
        self.init()
        self.attribute = attribute
        self.headerTitle.text = self.attribute.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                      let self = self
                else {return}
                self.datePublish.accept(selectedDate)
            }).disposed(by: self.disposeBag)
    }
    
    override func reloadView(_ value: Any?) {
        guard self.attribute == .startDate,
              let date = value as? Date else {return}
        self.datePicker.date = date
    }
}
