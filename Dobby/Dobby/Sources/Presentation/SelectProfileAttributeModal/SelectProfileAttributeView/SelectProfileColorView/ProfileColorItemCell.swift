//
//  ProfileColorItemCell.swift
//  Dobby
//
//  Created by yongmin lee on 11/4/22.
//

import UIKit
import SnapKit

final class ProfileColorItemCell: UITableViewCell {
    
    // MARK: property
    static let ID = "ProfileColorItemCell"
    var profileColor: ProfileColor?
    var isOn: Bool = false
    
    // MARK: UI
    struct Metric {
        static let viewTitleFontSize: CGFloat = 16
        static let itemRectViewCornerRadius: CGFloat = 5
        static let itemRectViewWidth: CGFloat = 8
        static let itemRectViewHeight: CGFloat = 16
        static let tableViewCellSideInset: CGFloat = 30
        static let itemTitleLeftInset: CGFloat = 15
        static let checkBoxViewWidthHeight: CGFloat = 16
    }
    
    private let editProfileItemViewTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.appleSDGothicNeoMedium(size: Metric.viewTitleFontSize).getFont
        lbl.textColor = Palette.textBlack1
        return lbl
    }()
    
    private let itemRectView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = Metric.itemRectViewCornerRadius
        colorView.backgroundColor = .clear
        return colorView
    }()
    
    private let checkBoxView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "checkmark.square")
        return iv
    }()
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.checkBoxView.image = nil
        self.setCheckBox(isOn: self.isOn)
    }
    
    // MARK: method
    func setupUI() {
        
        let bgView = UIView()
        bgView.backgroundColor = .clear
        selectedBackgroundView = bgView
        
        self.addSubview(itemRectView)
        itemRectView.snp.makeConstraints {
            $0.width.equalTo(Metric.itemRectViewWidth)
            $0.height.equalTo(Metric.itemRectViewHeight)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(Metric.tableViewCellSideInset)
        }
        
        self.addSubview(editProfileItemViewTitle)
        editProfileItemViewTitle.snp.makeConstraints {
            $0.left.equalTo(itemRectView.snp.right).offset(Metric.itemTitleLeftInset)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(checkBoxView)
        checkBoxView.snp.makeConstraints {
            $0.width.equalTo(Metric.checkBoxViewWidthHeight)
            $0.height.equalTo(Metric.checkBoxViewWidthHeight)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(Metric.tableViewCellSideInset)
        }
    }
    
    func bind(profileColor: ProfileColor) {
        self.profileColor = profileColor
        self.itemRectView.backgroundColor = profileColor.getUIColor
        self.editProfileItemViewTitle.text = profileColor.description
    }
    
    func setCheckBox(isOn: Bool) {
        self.isOn = isOn
        if isOn {
            checkBoxView.image = UIImage(systemName: "checkmark.square.fill")?
                .withTintColor(
                    Palette.mainThemeBlue1,
                    renderingMode: .alwaysOriginal
                )
        } else {
            checkBoxView.image = UIImage(systemName: "checkmark.square")
        }
    }
    
    func setSelectedColor(_ color: ProfileColor?) {
        if let color = color,
           let profileColor = self.profileColor {
            setCheckBox(isOn: color == profileColor)
        } else {
            setCheckBox(isOn: false)
        }
    }
}
