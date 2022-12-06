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
    let isShowMember: Bool
    let member: User
    let choreList: [Chore]
    
    // MARK: UI
    lazy var userProfile: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    private let stackContainerView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    
    // MARK: init
    init(isShowMember: Bool, member: User, choreList: [Chore]) {
        self.isShowMember = isShowMember
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
        self.snp.makeConstraints {
            $0.height.equalTo(40 * choreList.count)
        }
        
        if let profileUrl = self.member.profileUrl, isShowMember {
            userProfile.setImage(urlString: profileUrl)
        }
        self.addSubview(userProfile)
        userProfile.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.left.equalToSuperview()
            $0.width.equalTo(isShowMember ? 30 : 0)
            $0.height.equalTo(isShowMember ? 30 : 0)
        }
        
        self.addSubview(stackContainerView)
        stackContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(userProfile.snp.right).offset(isShowMember ? 16 : 0)
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        choreList.forEach { chore in
            let choreItemView = ChoreItemView(member: member, chore: chore)
            stackContainerView.addArrangedSubview(choreItemView)
        }
    }
}
