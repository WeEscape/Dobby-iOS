//
//  DailyChoreViewController.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit
import SnapKit
import RxGesture
import RxSwift
import RxCocoa
import RxDataSources

final class DailyChoreViewController: BaseViewController {

    // MARK: property
    let viewModel: DailyChoreViewModel
    let collectionDataSource = RxCollectionViewSectionedReloadDataSource<DateStrListSection> {
        datasource, collectionview, index, item in
        let cell = collectionview.dequeueReusableCell(
            withReuseIdentifier: DateStrCollectionCell.ID,
            for: index
        ) as! DateStrCollectionCell
        cell.setItem(item)
        return cell
    }
    
    // MARK: UI
    struct Metric {
        static let titleMargin: CGFloat = 40
        static let interitemSpacing: CGFloat = 10
        static let itemSize: CGSize = .init(width: 56, height: 56)
    }
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.avenirBlack(size: 24).getFont
        lbl.textColor = .black
        lbl.text = "집안일 현황"
        return lbl
    }()
    
    private let monthBtn: UIButton = {
        let btn = UIButton(configuration: .gray())
        btn.setTitle("12월", for: .normal)
        btn.setTitleColor(Palette.textBlack1, for: .normal)
        btn.tintColor = Palette.textGray1
        return btn
    }()
    
    // MARK: init
    init(viewModel: DailyChoreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let dateSelectCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = Metric.itemSize
        flowLayout.minimumInteritemSpacing = Metric.interitemSpacing
        flowLayout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.backgroundColor = .yellow
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(
            DateStrCollectionCell.self,
            forCellWithReuseIdentifier: DateStrCollectionCell.ID
        )
        return collection
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    // MARK: method
    func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(10)
            $0.left.equalToSuperview().inset(20)
        }
        
        self.view.addSubview(monthBtn)
        monthBtn.snp.makeConstraints {
            $0.width.equalTo(56)
            $0.height.equalTo(56)
            $0.left.equalToSuperview().inset(20)
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(20)
        }
        
        self.view.addSubview(dateSelectCollectionView)
        dateSelectCollectionView.snp.makeConstraints {
            $0.left.equalTo(monthBtn.snp.right).offset(20)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.centerY.equalTo(monthBtn.snp.centerY)
        }
    }
    
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
     
        viewModel.dateStringBehavior
            .distinctUntilChanged()
            .bind(to: self.dateSelectCollectionView.rx.items(dataSource: collectionDataSource))
            .disposed(by: self.disposeBag)
        
        viewModel.selectedDatePublish
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] dateIndex in
                self?.dateSelectCollectionView.selectItem(
                    at: .init(row: dateIndex, section: 0),
                    animated: false,
                    scrollPosition: .centeredHorizontally)
            }).disposed(by: self.disposeBag)
    }
    
    func bindAction() {
        self.rx.viewDidAppear
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.viewModel.viewDidAppear()
            }).disposed(by: self.disposeBag)
        
        self.monthBtn.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                print("Debug : monthBtn.rx.tap -> show today chore with colletionView today animation ")
            }).disposed(by: self.disposeBag)
        
        self.dateSelectCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.didTapCell(indexPath.row)
            }).disposed(by: self.disposeBag)
        
    }
}
