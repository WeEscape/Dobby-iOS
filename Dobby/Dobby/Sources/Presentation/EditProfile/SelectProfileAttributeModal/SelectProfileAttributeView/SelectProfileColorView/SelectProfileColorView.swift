//
//  SelectProfileColorView.swift
//  Dobby
//
//  Created by yongmin lee on 11/2/22.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa

final class SelectProfileColorView: ModalContentView {
    
    // MARK: property
    var attribute: ProfileAttribute?
    var colorList: [ProfileColor]?
    let selectColorPublish = PublishRelay<ProfileColor>.init()
    var selectedColor: ProfileColor?
    
    // MARK: UI
    struct Metric {
        static let tableViewBottomInset: CGFloat = 50
        static let tableViewHeight: CGFloat = 330
        static let headerViewHeight: CGFloat = 78
        static let tablewViewCellHeight: CGFloat = 44
    }
    
    private lazy var profileColorTableView: UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(
            ProfileColorItemCell.self,
            forCellReuseIdentifier: ProfileColorItemCell.ID
        )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(
            top: 0, left: 0, bottom: Metric.tableViewBottomInset, right: 0
        )
        return tableView
    }()
    
    // MARK: init
    override init() {
        super.init()
    }
    
    convenience init(
        attribute: ProfileAttribute,
        colorList: [ProfileColor]?
    ) {
        self.init()
        self.attribute = attribute
        self.headerTitle.text = attribute.description
        self.colorList = colorList
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: methods
    override func setupUI() {
        self.backgroundColor = .clear
        
        self.addSubview(bodyView)
        bodyView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        headerView.backgroundColor = .white
        self.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(50)
            $0.bottom.equalTo(bodyView.snp.top)
        }
        
        headerTitle.textColor = Palette.textBlack1
        headerTitle.font = DobbyFont.avenirMedium(size: 16).getFont
        headerView.addSubview(headerTitle)
        headerTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.addSubview(closeBackView)
        closeBackView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(self.headerView.snp.top)
        }
        
        profileColorTableView.snp.makeConstraints {
            $0.height.equalTo(Metric.tableViewHeight)
        }
        
        bodyView.addArrangedSubview(profileColorTableView)
        bodyView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(
                -(Metric.tableViewHeight + Metric.headerViewHeight)
            )
        }
    }
    
    override func reloadView(_ value: Any?) {
        guard let selectedColor = value as? ProfileColor else {return}
        self.selectedColor = selectedColor
        self.profileColorTableView.reloadData()
    }
}

// MARK: extension UITableView
extension SelectProfileColorView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.colorList?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileColorItemCell.ID,
            for: indexPath
        )
        if let profileColorCell = cell as? ProfileColorItemCell {
            if let colorItem = self.colorList?[indexPath.row] {
                profileColorCell.bind(profileColor: colorItem)
            }
            profileColorCell.setSelectedColor(selectedColor)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.tablewViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ProfileColorItemCell else {return}
        if let color = cell.profileColor {
            self.selectColorPublish.accept(color)
        }
    }
}
