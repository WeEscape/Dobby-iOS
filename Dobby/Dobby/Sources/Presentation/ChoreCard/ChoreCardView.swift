//
//  ChoreCardView.swift
//  Dobby
//
//  Created by yongmin lee on 12/3/22.
//

import UIKit
import SnapKit

final class ChoreCardView: UIView {
    
    // MARK: properties
    let date: Date
    let memberList: [User]
    let choreList: [[Chore]]
    
    // MARK: UI
    let dayLabel = UILabel()
    let dateLabel = UILabel()
    lazy var todayImageView = UIImageView()
    private let stackContainerView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    
    // MARK: init
    init(date: Date, memberList: [User], choreList: [[Chore]]) {
        self.date = date
        self.memberList = memberList
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
