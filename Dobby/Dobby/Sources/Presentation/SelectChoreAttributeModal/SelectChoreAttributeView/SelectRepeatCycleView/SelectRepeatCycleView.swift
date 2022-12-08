//
//  SelectRepeatCycleView.swift
//  Dobby
//
//  Created by yongmin lee on 11/6/22.
//

import UIKit
import RxRelay

final class SelectRepeatCycleView: ModalContentView {
    
    // MARK: property
    var attribute: ChoreAttribute!
    let repeatCyclePublish = PublishRelay<ChoreRepeatCycle>.init()
    var repeatCycleList: [ChoreRepeatCycle]?
    var selectedRepeatCycle: ChoreRepeatCycle?
    
    // MARK: UI
    struct Metric {
        static let headerViewHeight: CGFloat = 78
        static let tablewViewCellHeight: CGFloat = 50
        static let tableViewHeight: CGFloat = 300
    }
    
    private lazy var repeatCycleTableView: UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(
            SelectRepeatCycleCell.self,
            forCellReuseIdentifier: SelectRepeatCycleCell.ID
        )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(top: 10, left: 0, bottom: 20, right: 0)
        return tableView
    }()
    
    // MARK: init
    convenience init(
        attribute: ChoreAttribute,
        repeatCycleList: [ChoreRepeatCycle]?
    ) {
        self.init()
        self.attribute = attribute
        self.headerTitle.text = attribute.description
        self.repeatCycleList = repeatCycleList
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
        
        repeatCycleTableView.snp.makeConstraints {
            $0.height.equalTo(Metric.tableViewHeight)
        }
        
        bodyView.addArrangedSubview(repeatCycleTableView)
        bodyView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(
                -(Metric.tableViewHeight + Metric.headerViewHeight)
            )
        }
        
    }
    
    override func reloadView(_ value: Any?) {
        guard let selectedRepeatCycle = value as? ChoreRepeatCycle else {return}
        self.selectedRepeatCycle = selectedRepeatCycle
        self.repeatCycleTableView.reloadData()
    }
}

extension SelectRepeatCycleView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repeatCycleList?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectRepeatCycleCell.ID,
            for: indexPath
        )
        if let repeatCycleCell = cell as? SelectRepeatCycleCell {
            if let repeatCycle = self.repeatCycleList?[indexPath.row] {
                repeatCycleCell.bind(repeatCyle: repeatCycle)
            }
            repeatCycleCell.setSelectedCycle(self.selectedRepeatCycle)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.tablewViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectRepeatCycleCell
        else {return}
        if let repeatCyle = cell.repeatCyle {
            self.repeatCyclePublish.accept(repeatCyle)
        }
    }
}
