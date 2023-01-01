//
//  AlarmSwitchItemView.swift
//  Dobby
//
//  Created by yongmin lee on 1/2/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AlarmSwitchItemView: UIView {
    
    // MARK: properties
    var disposeBag = DisposeBag()
    var defaultTime: Date {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.hour, .minute], from: Date())
        component.hour = 8
        component.minute = 0
        let time = calendar.date(from: component)
        return time!
    }
    
    // MARK: UI
    private let leftTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.avenirMedium(size: 18).getFont
        return lbl
    }()
    
    private let bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = Palette.lineGray1
        return line
    }()
    
    private let alarmSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = Palette.mainThemeBlue1
        sw.preferredStyle = .sliding
        return sw
    }()
    
    private let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.minuteInterval = 15
        picker.datePickerMode = .time
        return picker
    }()
    
    // MARK: init
    init(
        leftText: String,
        textColor: UIColor = Palette.textGray1
    ) {
        super.init(frame: .zero)
        self.leftTitleLabel.text = leftText
        self.leftTitleLabel.textColor = textColor
        self.setupUI()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
    // MARK: methods
    func setupUI() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        self.addSubview(leftTitleLabel)
        leftTitleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(39)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
        
        self.addSubview(alarmSwitch)
        alarmSwitch.snp.makeConstraints {
            $0.right.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(timePicker)
        timePicker.snp.makeConstraints {
            $0.right.equalTo(alarmSwitch.snp.left).inset(-10)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: Rx bind
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        
    }
    
    func bindAction() {
        self.timePicker.rx.value
            .subscribe(onNext: { time in
                print("Debug : timePicker val -> \(time)")
            }).disposed(by: self.disposeBag)
        
        self.alarmSwitch.rx.value
            .subscribe(onNext: { [weak self] isOn in
                guard let self = self else {return}
                self.timePicker.setDate(self.defaultTime, animated: false)
                self.timePicker.isHidden = !isOn
            }).disposed(by: self.disposeBag)
    }
}
