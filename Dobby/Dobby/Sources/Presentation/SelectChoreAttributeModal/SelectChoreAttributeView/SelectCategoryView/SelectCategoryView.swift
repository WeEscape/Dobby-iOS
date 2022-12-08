//
//  SelectCategoryView.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import UIKit
import RxRelay

final class SelectCategoryView: ModalContentView {
    
    // MARK: property
    var attribute: ChoreAttribute!
    let categoryPublish = PublishRelay<Category>.init()
    var categoryList: [Category]?
    var selectedCategory: Category?
    
    // MARK: UI
    struct Metric {
        static let headerViewHeight: CGFloat = 78
        static let tablewViewCellHeight: CGFloat = 50
        static let tableViewHeight: CGFloat = 400
    }
    
    private lazy var categoryTableView: UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(
            SelectCategoryCell.self,
            forCellReuseIdentifier: SelectCategoryCell.ID
        )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(top: 10, left: 0, bottom: 20, right: 0)
        return tableView
    }()
    
    // MARK: init
    convenience init(
        attribute: ChoreAttribute,
        categoryList: [Category]
    ) {
        self.init()
        self.attribute = attribute
        self.headerTitle.text = attribute.description
        self.categoryList = categoryList
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
        guard let selectedCategory = value as? Category else {return}
        self.selectedCategory = selectedCategory
        self.categoryTableView.reloadData()
    }
}

extension SelectCategoryView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryList?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectCategoryCell.ID,
            for: indexPath
        )
        if let categoryCell = cell as? SelectCategoryCell {
            if let category = self.categoryList?[safe: indexPath.row] {
                categoryCell.bind(category: category)
            }
            categoryCell.setSelectedCategory(self.selectedCategory)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.tablewViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectCategoryCell
        else {return}
        if let category = cell.category {
            self.categoryPublish.accept(category)
        }
    }
}
