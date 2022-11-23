////
////  SelectCategoryView.swift
////  Dobby
////
////  Created by yongmin lee on 11/20/22.
////
//
//import Foundation
//import RxRelay
//
//final class SelectCategoryView: ModalContentView {
//    
//    // MARK: property
//    var attribute: ChoreAttribute!
//    let categoryPublish = PublishRelay<Category>.init()
//    var categoryList: [Category]?
//    var selectedCategory: Category?
//    
//    // MARK: UI
//    struct Metric {
//        static let headerViewHeight: CGFloat = 78
//        static let tablewViewCellHeight: CGFloat = 44
//        static let tableViewHeight: CGFloat = 220
//    }
//    
//    private lazy var categoryTableView: UITableView = {
//        var tableView = UITableView()
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = .white
//        tableView.register(
//            SelectRepeatCycleCell.self,
//            forCellReuseIdentifier: SelectRepeatCycleCell.ID
//        )
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.contentInset = .zero
//        return tableView
//    }()
//    
//    // MARK: init
//    convenience init(
//        attribute: ChoreAttribute,
//        categoryList: [Category]
//    ) {
//        self.init()
//        self.attribute = attribute
//        self.headerTitle.text = attribute.description
//        self.categoryList = categoryList
//    }
//    
//    override init() {
//        super.init()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: methods
//    override func setupUI() {
//        super.setupUI()
//        
//        categoryTableView.snp.makeConstraints {
//            $0.height.equalTo(Metric.tableViewHeight)
//        }
//        
//        bodyView.addArrangedSubview(categoryTableView)
//        bodyView.snp.updateConstraints {
//            $0.bottom.equalToSuperview().inset(
//                -(Metric.tableViewHeight + Metric.headerViewHeight)
//            )
//        }
//        
//    }
//    
//    override func reloadView(_ value: Any?) {
//        guard let selectedCategory = value as? Category else {return}
//        self.selectedCategory = selectedCategory
//        self.categoryTableView.reloadData()
//    }
//}
//
//extension SelectCategoryView: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.categoryList?.count ?? 0
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(
//        _ tableView: UITableView,
//        cellForRowAt indexPath: IndexPath
//    ) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(
//            withIdentifier: SelectRepeatCycleCell.ID,
//            for: indexPath
//        )
//        if let repeatCycleCell = cell as? SelectRepeatCycleCell {
//            if let repeatCycle = self.categoryList?[safe: indexPath.row] {
////                repeatCycleCell.bind(repeatCyle: repeatCycle)
//            }
////            repeatCycleCell.setSelectedColor(self.selectedRepeatCycle)
//        }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return Metric.tablewViewCellHeight
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        guard let cell = tableView.cellForRow(at: indexPath) as? SelectRepeatCycleCell
//        else {return}
//        if let repeatCyle = cell.repeatCyle {
//            self.categoryPublish.accept(repeatCyle)
//        }
//    }
//}
