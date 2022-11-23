//
//  SelectUserView.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import UIKit
import RxRelay

final class SelectUserView: ModalContentView {
    
    // MARK: property
    var attribute: ChoreAttribute!
    let userPublish = PublishRelay<User>.init()
    var userList: [User]?
    var selectedUser: User?
    
    // MARK: UI
    struct Metric {
        static let headerViewHeight: CGFloat = 78
        static let tablewViewCellHeight: CGFloat = 44
        static let tableViewHeight: CGFloat = 220
    }
    
    private lazy var categoryTableView: UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(
            SelectUserCell.self,
            forCellReuseIdentifier: SelectUserCell.ID
        )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .zero
        return tableView
    }()
    
    // MARK: init
    convenience init(
        attribute: ChoreAttribute,
        userList: [User]
    ) {
        self.init()
        self.attribute = attribute
        self.headerTitle.text = attribute.description
        self.userList = userList
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: methods
    override func setupUI() {
        super.setupUI()
        
        categoryTableView.snp.makeConstraints {
            $0.height.equalTo(Metric.tableViewHeight)
        }
        
        bodyView.addArrangedSubview(categoryTableView)
        bodyView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(
                -(Metric.tableViewHeight + Metric.headerViewHeight)
            )
        }
        
    }
    
    override func reloadView(_ value: Any?) {
        guard let selectedUser = value as? User else {return}
        self.selectedUser = selectedUser
        self.categoryTableView.reloadData()
    }
}

extension SelectUserView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectUserCell.ID,
            for: indexPath
        )
        if let userCell = cell as? SelectUserCell {
            if let user = self.userList?[safe: indexPath.row] {
                userCell.bind(user: user)
            }
            userCell.setSelectedUser(self.selectedUser)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.tablewViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectUserCell
        else {return}
        if let user = cell.user {
            self.userPublish.accept(user)
        }
    }
}
