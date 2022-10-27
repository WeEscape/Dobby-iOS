//
//  AddChoreAttributeView.swift
//  Dobby
//
//  Created by yongmin lee on 10/24/22.
//

import UIKit
import SnapKit

protocol AddChoreAttributeViewDelegate: AnyObject {
    func extendView(attribute: ChoreAttribute)
    func showAlert(attribute: ChoreAttribute)
}

class AddChoreAttributeView: UIView {
    
    weak var delegate: AddChoreAttributeViewDelegate?
    var attribute: ChoreAttribute
    
    init(attribute: ChoreAttribute) {
        self.attribute = attribute
        super.init(frame: .zero)
        self.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAddChoreAttributeView))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapAddChoreAttributeView() {
    }
}
