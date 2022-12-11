//
//  ChoreCardView.swift
//  Dobby
//
//  Created by yongmin lee on 12/3/22.
//

import UIKit
import RxOptional
import SnapKit
import RxCocoa

final class ChoreCardView: UIView {
    
    // MARK: properties
    let choreCardPeriod: ChorePeriodical
    let date: Date
    let memberList: [User]
    let choreArr: [Chore]
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
        stack.spacing = 10
        return stack
    }()
    
    // MARK: init
    init(
        choreCardPeriod: ChorePeriodical,
        date: Date,
        memberList: [User],
        choreArr: [Chore],
        viewModel: ChoreCardViewModel
    ) {
        self.choreCardPeriod = choreCardPeriod
        self.date = date
        self.memberList = memberList
        self.choreArr = choreArr
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
            $0.height.equalTo(40 * choreArr.count + 80) // 80 =. 라벨 여백
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
        
        memberList.forEach { member in
            let chores = choreArr.filter { chore in
                return chore.ownerList?.contains(where: { choreOwner in
                    choreOwner.userId == member.userId
                }) ?? false
            }
            if chores.isNotEmpty {
                let choreItemListView = ChoreItemListView(
                    isShowMember: choreCardPeriod == .daily ? false : true,
                    member: member,
                    choreList: chores,
                    viewModel: viewModel
                )
                stackContainerView.addArrangedSubview(choreItemListView)
            }
        }
    }
}
