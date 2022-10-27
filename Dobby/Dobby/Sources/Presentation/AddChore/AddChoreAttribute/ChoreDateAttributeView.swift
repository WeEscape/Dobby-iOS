//
//  ChoreDateAttributeView.swift
//  Dobby
//
//  Created by yongmin lee on 10/24/22.
//

import UIKit
import SnapKit

final class ChoreDateAttributeView: AddChoreAttributeView {
    
    override init(attribute: ChoreAttribute) {
        super.init(attribute: attribute)
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didTapAddChoreAttributeView() {
        self.delegate?.showAlert(attribute: self.attribute)
    }
}
