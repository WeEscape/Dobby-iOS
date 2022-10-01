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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BeaverLog.debug("\(String(describing: self)) viewDidLoad")
    }
    
    deinit {
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
}
