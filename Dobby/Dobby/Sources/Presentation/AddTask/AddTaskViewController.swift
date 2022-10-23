//
//  AddTaskViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit

final class AddTaskViewController: BaseViewController {
    
    // MARK: property
    let addTaskViewModel: AddTaskViewModel!
    
    // MARK: UI
    
    // MARK: init
    init(
        addTaskViewModel: AddTaskViewModel?
    ) {
        self.addTaskViewModel = addTaskViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: method
    func setupUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "집안일 등록"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = Palette.blue1
    }
    
    // MARK: Rx bind
    
}
