//
//  EditProfileItemView.swift
//  Dobby
//
//  Created by yongmin lee on 11/2/22.
//

import UIKit
import SnapKit

final class EditProfileItemView: UIView {
    
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
    
    private let itemTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.avenirMedium(size: 16).getFont
        return lbl
    }()
    
    private let leftArrowView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "arrow_right")
        return iv
    }()
    
    // MARK: init
    init(title: String) {
        editProfileItemViewTitle.text = title
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: method
    func setupUI() {
        
        self.addSubview(editProfileItemViewTitle)
        editProfileItemViewTitle.snp.makeConstraints {
            $0.left.equalToSuperview().inset(55)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(leftArrowView)
        leftArrowView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(55)
            $0.width.equalTo(12)
            $0.height.equalTo(12)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(itemTitle)
        itemTitle.snp.makeConstraints {
            $0.right.equalTo(leftArrowView.snp.left).inset(-7)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(itemRectView)
        itemRectView.snp.makeConstraints {
            $0.width.equalTo(8)
            $0.height.equalTo(16)
            $0.right.equalTo(itemTitle.snp.left).inset(-5)
            $0.centerY.equalToSuperview()
        }
    }
    
    func updateItemState(itemTitle: String, itemColor: UIColor) {
        self.itemTitle.text = itemTitle
        self.itemTitle.textColor = itemColor
        self.itemRectView.backgroundColor = itemColor
    }
}
