//
//  SelectUserCell.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import Foundation
import SnapKit

final class SelectUserCell: UITableViewCell {
    
    // MARK: property
    static let ID = "SelectUserCell"
    var user: User?
    var isOn: Bool = false
    
    // MARK: UI
    struct Metric {
        static let viewTitleFontSize: CGFloat = 18
        static let tableViewCellSideInset: CGFloat = 30
        static let checkBoxViewWidthHeight: CGFloat = 19
        static let cellTitleLabelLeftInset: CGFloat = 15
    }
    
    private let cellTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.appleSDGothicNeoMedium(size: Metric.viewTitleFontSize).getFont
        lbl.textColor = Palette.textBlack1
        return lbl
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
        
        self.addSubview(checkBoxView)
        checkBoxView.snp.makeConstraints {
            $0.width.equalTo(Metric.checkBoxViewWidthHeight)
            $0.height.equalTo(Metric.checkBoxViewWidthHeight)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(Metric.tableViewCellSideInset)
        }
        
        self.addSubview(cellTitleLabel)
        cellTitleLabel.snp.makeConstraints {
            $0.left.equalTo(checkBoxView.snp.right).offset(Metric.cellTitleLabelLeftInset)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind(user: User) {
        self.user = user
        self.cellTitleLabel.text = user.name
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
    
    func setSelectedUser(_ selectedUser: User?) {
        if let selectedUserId = selectedUser?.userId,
           let userId = self.user?.userId {
            setCheckBox(isOn: selectedUserId == userId)
        } else {
            setCheckBox(isOn: false)
        }
    }
}
