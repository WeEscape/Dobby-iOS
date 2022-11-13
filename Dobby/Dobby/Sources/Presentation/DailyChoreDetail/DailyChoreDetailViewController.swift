//
//  DailyChoreDetailViewController.swift
//  Dobby
//
//  Created by yongmin lee on 11/13/22.
//

import UIKit
import SnapKit

final class DailyChoreDetailViewController: UIViewController {
    
    var dateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("debug : DailyChoreDetailVC viewDidLoad")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("debug : DailyChoreDetailVC viewDidAppear -> \(dateLabel.text ?? "dateText")")
    }
    
    func setupUI() {
        let red = CGFloat(arc4random_uniform(256)) / 255
        let green = CGFloat(arc4random_uniform(256)) / 255
        let blue = CGFloat(arc4random_uniform(256)) / 255
        self.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1).withAlphaComponent(0.5)
        
        dateLabel.font = .systemFont(ofSize: 30, weight: .bold)
        self.view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
