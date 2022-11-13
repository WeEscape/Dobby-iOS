//
//  DateSelectCollectionCell.swift
//  Dobby
//
//  Created by yongmin lee on 11/11/22.
//

import UIKit
import SnapKit
import RxSwift

class DateSelectCollectionCell: UICollectionViewCell {

    static var ID = "DateStrCollectionCell"
    var day: Int = 0
    
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    override var isSelected: Bool {
        didSet {
            self.titleLabel.backgroundColor = isSelected ? .yellow : .orange
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        backgroundColor = .orange

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setDate(_ date: Date) {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
        print("Debug : cell day -> \(component.day!), 요일: \(component.weekday!)")
        titleLabel.text = "\(component.day ?? 0)"
        self.day = component.day ?? 0
    }
}
