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
    struct Metric {
        static let headerViewHeight: CGFloat = 78
    }
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
        self.backgroundColor = .clear
        
        self.addSubview(datePicker)
        datePicker.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(-Metric.headerViewHeight-datePicker.frame.height)
        }
        
        self.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(Metric.headerViewHeight)
            $0.bottom.equalTo(datePicker.snp.top)
        }
    }
    
    override func showAnimation() {
        UIView.animate(withDuration: 0.1, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.datePicker.snp.updateConstraints {
                $0.bottom.equalToSuperview()
            }
            UIView.animate(withDuration: 0.5) {
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
}
