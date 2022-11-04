//
//  ProfileColorItemView.swift
//  Dobby
//
//  Created by yongmin lee on 11/4/22.
//

import UIKit
import SnapKit
import RxCocoa
import RxGesture

final class ProfileColorItemView: UITableViewCell {
    
    // MARK: property
    static let ID = "ProfileColorItemCell"
    var profileColor: ProfileColor?
    
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
        self.profileColor = nil
        self.checkBoxView.image = nil
    }
    
    // MARK: method
    func setupUI() {
        
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
        print("Debug : color item cell bind -> \(profileColor.description)")
        self.profileColor = profileColor
        self.itemRectView.backgroundColor = profileColor.getUIColor
        self.editProfileItemViewTitle.text = profileColor.description
    }
    
    func setcheckBoxOn() {
        checkBoxView.image = UIImage(systemName: "checkmark.square.fill")?
            .withTintColor(
                Palette.mainThemeBlue1,
                renderingMode: .alwaysOriginal
            )
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        if selected {
            checkBoxView.image = UIImage(systemName: "checkmark.square.fill")?
                .withTintColor(
                    Palette.mainThemeBlue1,
                    renderingMode: .alwaysOriginal
                )
        } else {
            checkBoxView.image = UIImage(systemName: "checkmark.square")
        }
    }
}
