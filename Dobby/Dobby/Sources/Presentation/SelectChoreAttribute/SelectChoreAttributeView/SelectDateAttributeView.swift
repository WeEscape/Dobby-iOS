//
//  SelectDateAttributeView.swift
//  Dobby
//
//  Created by yongmin lee on 10/29/22.
//

import UIKit
import SnapKit
import RxCocoa

final class SelectDateAttributeView: SelectChoreAttributeView {
    
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
    
    override func setState(_ value: Any?) {
        guard self.attribute == .date,
              let date = value as? Date else {return}
        self.datePicker.date = date
    }
}
