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
import RxDataSources

final class SelectProfileColorView: ModalContentView {
    
    // MARK: property
    var attribute: ProfileAttribute?
    let colorPublish = PublishRelay<ProfileColor>.init()
    let colorList = [ProfileColorSection.init(colorList: ProfileColor.allCases)]
    private var tableViewDataSource: RxTableViewSectionedReloadDataSource<ProfileColorSection>
    
    // MARK: init
    override init() {
        self.tableViewDataSource = Self.tableViewFactory()
        super.init()
    }
    
    convenience init(attribute: ProfileAttribute) {
        self.init()
        self.attribute = attribute
        self.headerTitle.text = attribute.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    private let profileColorTableView: UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension // dynamic height
        tableView.estimatedRowHeight = 44.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            ProfileColorItemView.self,
            forCellReuseIdentifier: ProfileColorItemView.ID
        )
        tableView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        return tableView
    }()
    
    // MARK: methods
    override func setupUI() {
        super.setupUI()

        bodyView.addArrangedSubview(profileColorTableView)
        profileColorTableView.snp.makeConstraints {
            $0.height.equalTo(440)
        }
        bindState()
    }
    
    override func bindAction() {
        super.bindAction()
        
        Observable
            .zip(
                profileColorTableView.rx.itemSelected,
                profileColorTableView.rx.modelSelected(ProfileColor.self)
            )
            .subscribe(onNext: { [weak self]  indexPath, model in
                guard let self = self else {return}
                self.profileColorTableView.deselectRow(at: indexPath, animated: false)
                let cell = self.profileColorTableView.cellForRow(at: indexPath) as? ProfileColorItemView
                cell?.setcheckBoxOn()
                self.colorPublish.accept(model)
            }).disposed(by: self.disposeBag)  
    }
    
    func bindState() {
        Observable.just(colorList)
            .bind(to: profileColorTableView.rx.items(dataSource: self.tableViewDataSource))
            .disposed(by: disposeBag)
    }
    
    static func tableViewFactory() -> RxTableViewSectionedReloadDataSource<ProfileColorSection> {
        return .init { _, tableView, index, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ProfileColorItemView.ID,
                for: index
            )
            if let profileColorCell = cell as? ProfileColorItemView {
                profileColorCell.bind(profileColor: item)
            }
            return cell
        }
    }
}
