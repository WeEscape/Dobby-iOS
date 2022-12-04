//
//  ChoreItemView.swift
//  Dobby
//
//  Created by yongmin lee on 12/4/22.
//

import UIKit
import SnapKit

final class ChoreItemView: UIView {
    
    // MARK: properties
    let chore: Chore
    
    // MARK: UI
    
    // MARK: init
    init(chore: Chore) {
        self.chore = chore
        super.init(frame: .zero)
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
        self.backgroundColor = .white
    }
}
