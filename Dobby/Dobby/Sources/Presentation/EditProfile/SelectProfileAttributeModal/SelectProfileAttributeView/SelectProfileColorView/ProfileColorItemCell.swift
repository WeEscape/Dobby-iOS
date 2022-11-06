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
    private let editProfileItemViewTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.appleSDGothicNeoMedium(size: 16).getFont
        lbl.textColor = Palette.textBlack1
        return lbl
    }()
    
    private let itemRectView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 5
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
            $0.width.equalTo(8)
            $0.height.equalTo(16)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(30)
        }
        
        self.addSubview(editProfileItemViewTitle)
        editProfileItemViewTitle.snp.makeConstraints {
            $0.left.equalTo(itemRectView.snp.right).offset(15)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(checkBoxView)
        checkBoxView.snp.makeConstraints {
            $0.width.equalTo(16)
            $0.height.equalTo(16)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(30)
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
