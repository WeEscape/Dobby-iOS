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
    weak var viewModel: ChoreCardViewModel?
    
    // MARK: UI
    private let userProfile: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.backgroundColor = .clear
        return iv
    }()
    
    private let stackContainerView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var isMeMark: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        let img = UIImage(systemName: "checkmark.circle.fill")?
            .withTintColor(
                Palette.mainThemeBlue1,
                renderingMode: .alwaysOriginal
            )
        iv.image = img
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        iv.isHidden = !self.checkShowMark()
        return iv
    }()
    
    // MARK: init
    init(
        isShowMember: Bool,
        member: User,
        choreList: [Chore],
        viewModel: ChoreCardViewModel?
    ) {
        self.isShowMember = isShowMember
        self.member = member
        self.choreList = choreList
        self.viewModel = viewModel
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
        
        self.addSubview(isMeMark)
        isMeMark.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.left.equalTo(userProfile.snp.left).inset(-6)
            $0.bottom.equalTo(userProfile.snp.bottom).offset(4)
        }
        
        self.addSubview(stackContainerView)
        stackContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(userProfile.snp.right).offset(isShowMember ? 10 : 0)
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        choreList.forEach { chore in
            let choreItemView = ChoreItemView(
                member: member,
                chore: chore,
                viewModel: viewModel
            )
            stackContainerView.addArrangedSubview(choreItemView)
        }
    }
    
    func checkShowMark() -> Bool {
        guard let viewModel = self.viewModel,
              viewModel.choreCardPeriod != .daily,
              let myId = viewModel.myInfo?.userId,
              let memberId = member.userId
        else {return false}
        if myId == memberId {
            return true
        }
        return false
    }
}
