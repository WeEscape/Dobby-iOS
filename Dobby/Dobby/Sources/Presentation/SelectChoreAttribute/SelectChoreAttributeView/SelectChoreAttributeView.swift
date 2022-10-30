//
//  SelectChoreAttributeView.swift
//  Dobby
//
//  Created by yongmin lee on 10/29/22.
//

import UIKit
import SnapKit
import RxRelay
import RxSwift
import RxCocoa

class SelectChoreAttributeView: UIView {
    
    // MARK: property
    let attribute: ChoreAttribute
    let didTapConfirm = PublishRelay<Void>.init()
    var disposeBag = DisposeBag()
    let datePublish = PublishRelay<Date>.init()
    
    // MARK: UI
    struct Metric {
        static let headerItemLeftRightInset: CGFloat = 20
    }
    
    let headerView: UIView = {
        let header = UIView()
        header.backgroundColor = Palette.mainThemeBlue1
        header.layer.cornerRadius = 12
        header.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return header
    }()
    
    lazy var headerTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = self.attribute.description
        lbl.textColor = .white
        lbl.font = DobbyFont.avenirMedium(size: 24).getFont
        return lbl
    }()
    
    let confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("닫기", for: .normal)
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
    }()
    
    // MARK: init
    init(attribute: ChoreAttribute) {
        self.attribute = attribute
        super.init(frame: .zero)
        self.setupUI()
        self.bindAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
    // MARK: methods
    func setupUI() {
        headerView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints {
            $0.right.equalToSuperview().inset(Metric.headerItemLeftRightInset)
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        headerView.addSubview(headerTitle)
        headerTitle.snp.makeConstraints {
            $0.left.equalToSuperview().inset(Metric.headerItemLeftRightInset)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bindAction() {
        self.confirmBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.didTapConfirm.accept(())
            }).disposed(by: self.disposeBag)
    }
    
    func showAnimation() {}
    
    func hideAnimation() {}
}
