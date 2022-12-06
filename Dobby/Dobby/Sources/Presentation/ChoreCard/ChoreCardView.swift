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
    weak var viewModel: ChoreCardViewModel?
    
    // MARK: UI
    lazy var weekdayLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = self.date.getWeekday()
        lbl.font = DobbyFont.avenirBlack(size: 16).getFont
        lbl.textColor = Palette.mainThemeBlue1
        return lbl
    }()
    
    lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = self.date.toStringWithoutTime()
        lbl.font = DobbyFont.avenirBlack(size: 16).getFont
        lbl.textColor = Palette.textBlack1
        return lbl
    }()
    
    lazy var todayImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "todayMark")
        iv.isHidden = !(self.date.isSame(with: Date()))
        return iv
    }()
    
    private let stackContainerView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    
    // MARK: init
    init(date: Date, memberList: [User], choreList: [[Chore]], viewModel: ChoreCardViewModel) {
        self.date = date
        self.memberList = memberList
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
        self.layer.cornerRadius = 15
        self.layer.makeShadow()
        
        // height 계산
        self.snp.makeConstraints {
            let allChoreList = choreList.flatMap { $0 }
            $0.height.equalTo(40 * allChoreList.count + 80) // 60 =. 라벨 여백
        }
        
        self.addSubview(weekdayLabel)
        weekdayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(30)
        }
        
        self.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(weekdayLabel.snp.centerY)
            $0.left.equalTo(weekdayLabel.snp.right).offset(16)
        }
        
        self.addSubview(todayImageView)
        todayImageView.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(20)
            $0.centerY.equalTo(weekdayLabel.snp.centerY)
            $0.right.equalToSuperview().inset(20)
        }
        
        self.addSubview(stackContainerView)
        stackContainerView.snp.makeConstraints {
            $0.top.equalTo(weekdayLabel.snp.bottom).offset(20)
            $0.left.equalTo(weekdayLabel.snp.left)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        for (memberIdx, member) in memberList.enumerated() {
            let choreItemListView = ChoreItemListView(
                isShowMember: self.memberList.count == 1 ? false : true,
                member: member,
                choreList: choreList[memberIdx]
            )
            stackContainerView.addArrangedSubview(choreItemListView)
        }
    }
}
