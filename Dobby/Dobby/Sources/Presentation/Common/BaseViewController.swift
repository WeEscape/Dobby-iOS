//
//  BaseViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/1/22.
//

import UIKit
import RxSwift
import SnapKit

class BaseViewController: UIViewController {
    
    // MARK: property
    var disposeBag: DisposeBag = .init()
    let loadingView = LoadingIndicatorView()
    
    // MARK: init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        BeaverLog.debug("\(String(describing: self)) init")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.disposeBag = .init()
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        BeaverLog.verbose("\(String(describing: self)) viewDidLoad")
    }
    
    // MARK: methods
    func createLineView() -> UIView {
        let line = UIView()
        line.backgroundColor = Palette.lineGray1
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }
    
    func showLoading() {
        self.loadingView.isHidden = false
        self.view.addSubview(self.loadingView)
        self.loadingView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
            $0.top.equalToSuperview()
        }
        self.view.bringSubviewToFront(self.loadingView)
        self.view.layoutIfNeeded()
    }
    
    func hideLoading() {
        self.loadingView.isHidden = true
        self.loadingView.removeFromSuperview()
        self.view.layoutIfNeeded()
    }
}
