//
//  DateSelectCollectionCell.swift
//  Dobby
//
//  Created by yongmin lee on 11/11/22.
//

import UIKit
import SnapKit
import RxSwift

final class DateSelectCollectionCell: UICollectionViewCell {

    static var ID = "DateSelectCollectionCell"
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = DobbyFont.avenirMedium(size: 15).getFont
        label.textColor = Palette.textBlack1
        return label
    }()
    
    private let weekDayLabel: UILabel = {
        let label = UILabel()
        label.font = DobbyFont.avenirMedium(size: 15).getFont
        label.textColor = Palette.textBlack1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .lightGray.withAlphaComponent(0.15) : .white
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if self.dayLabel.text == "일" {
            self.weekDayLabel.textColor = .red
        } else if self.dayLabel.text == "토" {
            self.weekDayLabel.textColor = .blue
        } else {
            self.weekDayLabel.textColor = Palette.textBlack1
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        backgroundColor = .white
        self.layer.cornerRadius = 15
        
        addSubview(weekDayLabel)
        weekDayLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
        }
        
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(weekDayLabel.snp.bottom)
        }
    }
    
    func setDate(_ date: Date) {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
        let day = component.day ?? 0
        let month = component.month ?? 0
        dayLabel.text = day == 1 ? "\(month)/\(day)" : "\(day)"
        if let weekday = component.weekday {
            if weekday == 1 {
                self.weekDayLabel.text = "일"
                self.weekDayLabel.textColor = .red
            } else if weekday == 2 {
                self.weekDayLabel.text = "월"
            } else if weekday == 3 {
                self.weekDayLabel.text = "화"
            } else if weekday == 4 {
                self.weekDayLabel.text = "수"
            } else if weekday == 5 {
                self.weekDayLabel.text = "목"
            } else if weekday == 6 {
                self.weekDayLabel.text = "금"
            } else if weekday == 7 {
                self.weekDayLabel.text = "토"
                self.weekDayLabel.textColor = .blue
            }
        }
    }
}
