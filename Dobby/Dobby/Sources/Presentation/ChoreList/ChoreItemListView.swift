//
//  ChoreItemListView.swift
//  Dobby
//
//  Created by yongmin lee on 12/3/22.
//

import UIKit
import SnapKit

final class ChoreItemListView: UIView {
    
    // MARK: properties
    let member: User
    let choreList: [Chore]
    
    // MARK: UI
    
    // MARK: init
    init(member: User, choreList: [Chore]) {
        self.member = member
        self.choreList = choreList
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
    
    func bind() {
        // 데이터
        
        // height upate
    }
}
