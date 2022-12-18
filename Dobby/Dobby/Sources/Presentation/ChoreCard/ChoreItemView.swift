//
//  ChoreItemView.swift
//  Dobby
//
//  Created by yongmin lee on 12/4/22.
//

import UIKit
import SnapKit
import RxSwift
import RxGesture

final class ChoreItemView: UIView {
    
    // MARK: properties
    let member: User
    let chore: Chore
    weak var viewModel: ChoreCardViewModel?
    
    // MARK: UI
    lazy var choreTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = self.chore.title
        if self.isFinished() {
            lbl.font = DobbyFont.avenirMedium(size: 18).getFont
            lbl.textColor = UIColor.systemGray3
        } else {
            lbl.font = DobbyFont.avenirBlack(size: 18).getFont
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
    
    lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "trash.fill")?
            .withTintColor(Palette.textGray1, renderingMode: .alwaysOriginal)
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleToFill
        btn.backgroundColor = .clear
        btn.isHidden = !self.isMyChore()
        return btn
    }()
    
    lazy var alarmBtn: UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "bell.fill")?
            .withTintColor(Palette.mainThemeBlue1, renderingMode: .alwaysOriginal)
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleToFill
        btn.backgroundColor = .clear
//        btn.isHidden = self.isMyChore()
        btn.isHidden = true
        return btn
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
        self.bind(viewModel: viewModel)
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
        
        self.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        self.addSubview(alarmBtn)
        alarmBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        self.addSubview(choreTitle)
        choreTitle.snp.makeConstraints {
            $0.left.equalTo(checkBox.snp.right).offset(16)
            $0.height.equalToSuperview()
            $0.right.equalToSuperview().inset(40)
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
    
    func didTapChoreItemView() {
        guard let memberId = member.userId,
              let ownerList = chore.ownerList,
              let owner = ownerList.first(where: { owner in
                  owner.userId == memberId
              })
        else {return}
        if isMyChore() {
            let toggleEnd = !(owner.isEnd == 1)
            viewModel?.toggleChoreIsEnd(chore, userId: memberId, isEnd: toggleEnd)
        } else {
            print("not my chore ")
        }
    }
    
    func isMyChore() -> Bool {
        guard let viewModel = self.viewModel,
              viewModel.choreCardPeriod != .daily
        else {return true}
        
        guard let myInfo = viewModel.myInfo,
              let memberId = member.userId,
              let ownerList = chore.ownerList,
              let owner = ownerList.first(where: { owner in
                  owner.userId == memberId
              })
        else {return false}
        if owner.userId == myInfo.userId {
            return true
        }
        return false
    }
    
    // MARK: RX bind
    func bind(viewModel: ChoreCardViewModel?) {
        guard let viewModel = viewModel else {return}
        bindAction(viewModel: viewModel)
    }
    
    func bindAction(viewModel: ChoreCardViewModel) {
        
        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.didTapChoreItemView()
            }).disposed(by: viewModel.disposBag)
        
        deleteBtn.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let chore = self?.chore else {return}
                self?.viewModel?.deleteChore(chore: chore)
            }).disposed(by: viewModel.disposBag)
        
        alarmBtn.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                print("debug : alarmBtn tapGesture()")
            }).disposed(by: viewModel.disposBag)
    }
}
