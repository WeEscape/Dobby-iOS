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
    let member: User
    let chore: Chore
    weak var viewModel: ChoreCardViewModel?
    
    // MARK: UI
    lazy var choreTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = self.chore.title
        lbl.font = DobbyFont.avenirMedium(size: 18).getFont
        if self.isFinished() {
            lbl.textColor = UIColor.systemGray2
        } else {
            lbl.textColor = Palette.textBlack1
        }
        return lbl
    }()
    
    lazy var checkBox: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        if self.isFinished() {
            iv.image = UIImage(systemName: "checkmark.square.fill")?
                .withTintColor(
                    UIColor.systemGray2,
                    renderingMode: .alwaysOriginal
                )
        } else {
            iv.image = UIImage(systemName: "square")?
                .withTintColor(
                    UIColor.systemGray2,
                    renderingMode: .alwaysOriginal
                )
        }
        return iv
    }()
    
    // MARK: init
    init(
        member: User,
        chore: Chore,
        viewModel: ChoreCardViewModel?
    ) {
        self.member = member
        self.chore = chore
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.setupUI()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapChoreItemView))
        self.addGestureRecognizer(tap)
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
            $0.height.equalTo(40)
        }
        
        self.addSubview(checkBox)
        checkBox.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalTo(20)
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(choreTitle)
        choreTitle.snp.makeConstraints {
            $0.left.equalTo(checkBox.snp.right).offset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func isFinished() -> Bool {
        let chore = self.chore.ownerList?.first(where: { owner in
            owner.userId == self.member.userId
        })
        if let isEnd = chore?.isEnd, isEnd == 1 {
            return true
        } else {
            return false
        }
    }
    
    @objc func didTapChoreItemView() {
        viewModel?.didTapChoreItem(self.chore)
    }
}
