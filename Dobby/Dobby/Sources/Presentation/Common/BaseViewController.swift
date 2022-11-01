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
}
