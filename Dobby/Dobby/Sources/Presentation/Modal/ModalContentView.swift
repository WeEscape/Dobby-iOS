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
import RxGesture

class ModalContentView: UIView {
    
    // MARK: property
    let didTapConfirm = PublishRelay<Void>.init()
    var disposeBag = DisposeBag()
    
    // MARK: UI
    struct Metric {
        static let headerItemLeftRightInset: CGFloat = 20
        static let headerViewHeight: CGFloat = 78
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
        lbl.textColor = .white
        lbl.font = DobbyFont.avenirMedium(size: 24).getFont
        return lbl
    }()
    
    let bodyView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    let closeBackView: UIView = {
        let back = UIView()
        back.backgroundColor = .clear
        return back
    }()
    
    // MARK: init
    init() {
        super.init(frame: .zero)
        BeaverLog.debug("\(String(describing: self)) init")
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
        self.backgroundColor = .clear
        
        self.addSubview(bodyView)
        bodyView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(Metric.headerViewHeight)
            $0.bottom.equalTo(bodyView.snp.top)
        }
        
        headerView.addSubview(headerTitle)
        headerTitle.snp.makeConstraints {
            $0.left.equalToSuperview().inset(Metric.headerItemLeftRightInset)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(closeBackView)
        closeBackView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(self.headerView.snp.top)
        }
    }
    
    func bindAction() {
        closeBackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.closeAnimation()
            }).disposed(by: self.disposeBag)
        
        self.headerView.rx.swipeGesture(.down)
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.closeAnimation()
            }).disposed(by: self.disposeBag)
    }
    
    func reloadView(_ value: Any?) {}
    
    func showAnimation() {
        self.layoutIfNeeded()
        self.bodyView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.layoutIfNeeded()
        }
    }
    
    func closeAnimation() {
        self.bodyView.snp.remakeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(self.snp.bottom).offset(Metric.headerViewHeight)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.didTapConfirm.accept(())
        })
    }
}
