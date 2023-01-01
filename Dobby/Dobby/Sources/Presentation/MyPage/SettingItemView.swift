//
//  SettingItemView.swift
//  Dobby
//
//  Created by yongmin lee on 11/1/22.
//

import UIKit
import SnapKit

final class SettingItemView: UIView {
    
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
    
    private let rightTitleLable: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.avenirMedium(size: 18).getFont
        return lbl
    }()
    
    // MARK: init
    init(
        leftText: String,
        textColor: UIColor = Palette.textGray1,
        rightText: String = ""
    ) {
        super.init(frame: .zero)
        self.leftTitleLabel.text = leftText
        self.leftTitleLabel.textColor = textColor
        self.rightTitleLable.text = rightText
        self.rightTitleLable.textColor = textColor
        self.setupUI()
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
        
        self.addSubview(rightTitleLable)
        rightTitleLable.snp.makeConstraints {
            $0.right.equalToSuperview().inset(39)
            $0.centerY.equalToSuperview()
        }
    }
}
