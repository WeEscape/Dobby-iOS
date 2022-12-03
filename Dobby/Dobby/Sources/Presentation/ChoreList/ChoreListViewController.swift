//
//  ChoreListViewController.swift
//  Dobby
//
//  Created by yongmin lee on 11/13/22.
//

import UIKit
import SnapKit

final class ChoreListViewController: BaseViewController {
    
    // MARK: property
    let viewModel: ChoreListViewModel
    
    // MARK: UI
    
    // MARK: init
    init(viewModel: ChoreListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: methods
    func setupUI() {
        
    }
    
}
