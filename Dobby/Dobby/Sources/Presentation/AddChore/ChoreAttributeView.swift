//
//  ChoreAttributeView.swift
//  Dobby
//
//  Created by yongmin lee on 10/24/22.
//

import UIKit
import SnapKit

protocol ChoreAttributeViewDelegate: AnyObject {
    func didTapChoreAttribute(attribute: ChoreAttribute)
    func editingChanged(value: String?)
}

class ChoreAttributeView: UIView {
    
    // MARK: property
    weak var delegate: ChoreAttributeViewDelegate?
    var attribute: ChoreAttribute
    
    // MARK: UI
    struct Metric {
        static let titleFontSize: CGFloat = 16
        static let viewHeight: CGFloat = 48
        static let iconViewWidthHeight: CGFloat = 20
        static let titleLabelLeftMargin: CGFloat = 8
        static let arrowViewWidthHeight: CGFloat = 12
    }
    
    lazy var iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = self.attribute.icon
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Palette.textBlack1
        lbl.font = DobbyFont.appleSDGothicNeoMedium(size: Metric.titleFontSize).getFont
        lbl.text = self.attribute.description
        lbl.isUserInteractionEnabled = false
        return lbl
    }()
    
    private let arrowView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "arrow_down")
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    // MARK: init
    init(attribute: ChoreAttribute) {
        self.attribute = attribute
        super.init(frame: .zero)
        self.setupUI()
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapChoreAttributeView)
        )
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: method
    func setupUI() {
        self.snp.makeConstraints {
            $0.height.equalTo(Metric.viewHeight)
        }
        self.backgroundColor = .white
        
        self.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(Metric.iconViewWidthHeight)
            $0.height.equalTo(Metric.iconViewWidthHeight)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(Metric.titleLabelLeftMargin)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(arrowView)
        arrowView.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(Metric.arrowViewWidthHeight)
            $0.height.equalTo(Metric.arrowViewWidthHeight)
        }
    }
    
    func updateTitle(title: String?) {
        self.titleLabel.text = title
    }
    
    @objc func didTapChoreAttributeView() {
        self.delegate?.didTapChoreAttribute(attribute: self.attribute)
    }
}
