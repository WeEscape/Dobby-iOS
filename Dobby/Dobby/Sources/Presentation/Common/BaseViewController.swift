//
//  BaseViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/1/22.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    var disposeBag: DisposeBag = .init()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        BeaverLog.debug("\(String(describing: self)) init")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        BeaverLog.debug("\(String(describing: self)) init")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BeaverLog.debug("\(String(describing: self)) viewDidLoad")
    }
    
    deinit {
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
}
