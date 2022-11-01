//
//  EditProfileViewController.swift
//  Dobby
//
//  Created by yongmin lee on 11/1/22.
//

import UIKit
import SnapKit

final class EditProfileViewController: BaseViewController {
    
    // MARK: property
    weak var coordinator: EditProfileCoordinator?
    let viewModel: EditProfileViewModel
    
    // MARK: init
    init(
        coordinator: EditProfileCoordinator?,
        viewModel: EditProfileViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
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
        self.navigationItem.title = "프로필 수정"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.topViewController?.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = Palette.mainThemeBlue1
    }
}
