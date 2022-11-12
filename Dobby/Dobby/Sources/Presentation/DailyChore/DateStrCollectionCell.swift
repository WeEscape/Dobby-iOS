//
//  DateStrCollectionCell.swift
//  Dobby
//
//  Created by yongmin lee on 11/11/22.
//

import UIKit
import SnapKit
import RxSwift

class DateStrCollectionCell: UICollectionViewCell {

    static var ID = "DateStrCollectionCell"

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

    func setItem(_ item: String) {
        guard let date = item.toDate(dateFormat: "yyyy-MM-dd") else {return}
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .day], from: date)
        print("Debug : cell day -> \(component.day!)")
        titleLabel.text = "\(component.day ?? 0)"
    }
}
