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
import RxOptional

final class DailyChoreViewController: BaseViewController {

    // MARK: property
    weak var coordinator: DailyChoreCoordinator?
    let viewModel: DailyChoreViewModel
    let collectionDataSource = RxCollectionViewSectionedReloadDataSource<DateListSection> {
        _, collectionview, index, item in
        let cell = collectionview.dequeueReusableCell(
            withReuseIdentifier: DateSelectCollectionCell.ID,
            for: index
        )
        if let cell = cell as? DateSelectCollectionCell {
            cell.setDate(item)
        }
        return cell
    }
    
    // MARK: UI
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = DobbyFont.avenirBlack(size: 24).getFont
        lbl.textColor = .black
        lbl.text = "집안일 현황"
        return lbl
    }()
    
    private let monthBtn: UIButton = {
        let btn = UIButton(configuration: .gray())
        btn.setTitle("월", for: .normal)
        btn.setTitleColor(Palette.textBlack1, for: .normal)
        btn.tintColor = Palette.textGray1
        return btn
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        vc.view.backgroundColor = Palette.pageBackground
        vc.delegate = self
        vc.dataSource = self
        return vc
    }()
    
    private let addChoreBtn: UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "plus")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleToFill
        btn.backgroundColor = Palette.mainThemeBlue1
        btn.layer.cornerRadius = 30
        btn.layer.makeShadow()
        return btn
    }()
    
    // MARK: init
    init(viewModel: DailyChoreViewModel, coordinator: DailyChoreCoordinator) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let dateSelectCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = .init(width: 40, height: 60)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 15
        flowLayout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(
            DateSelectCollectionCell.self,
            forCellWithReuseIdentifier: DateSelectCollectionCell.ID
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
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }
        
//        self.view.addSubview(monthBtn)
//        monthBtn.snp.makeConstraints {
//            $0.width.equalTo(60)
//            $0.height.equalTo(60)
//            $0.left.equalToSuperview().inset(20)
//            $0.top.equalTo(self.titleLabel.snp.bottom).offset(20)
//        }
        monthBtn.isHidden = true
        
        self.view.addSubview(dateSelectCollectionView)
        dateSelectCollectionView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(70)
            $0.top.equalTo(self.titleLabel.snp.bottom)
        }
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(dateSelectCollectionView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        pageViewController.didMove(toParent: self)
        
        view.addSubview(addChoreBtn)
        addChoreBtn.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(60)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    func setMonthBtnTitle(_ month: Int?) {
        guard let month = month else {return}
        monthBtn.setTitle("\(month)월", for: .normal)
    }
    
    func updateSelectedDate(_ selectedIndexList: [Int]) {
        let oldPageIndex = selectedIndexList.first ?? 0
        let newpageIndex = selectedIndexList.last ?? 0
        let direction: UIPageViewController.NavigationDirection =
        oldPageIndex < newpageIndex ? .forward : .reverse
        
        if let selectedVC = self.viewModel.pageVCDataSourceBehavior.value[safe: newpageIndex] {
            self.pageViewController.setViewControllers(
                [selectedVC],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
        self.dateSelectCollectionView.selectItem(
            at: .init(row: newpageIndex, section: 0),
            animated: true,
            scrollPosition: .centeredHorizontally
        )
    }
    
    // MARK: Rx bind
    func bind() {
        bindState()
        bindAction()
    }
    
    func bindState() {
        viewModel.dateListSectionBehavior
            .distinctUntilChanged()
            .bind(to: self.dateSelectCollectionView.rx.items(dataSource: collectionDataSource))
            .disposed(by: self.disposeBag)
        
        viewModel.selectedDatePublish
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] dateComponents in
                self?.setMonthBtnTitle(dateComponents.month)
            }).disposed(by: self.disposeBag)
        
        viewModel.selectedCellIndexBehavior
            .filterNil()
            .asDriver(onErrorJustReturn: [0, 0])
            .drive(onNext: { [weak self] selectedIndexList in
                self?.updateSelectedDate(selectedIndexList)
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
                self?.viewModel.didTapGotoToday()
            }).disposed(by: self.disposeBag)
        
        self.dateSelectCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.didSelectCell(indexPath.row)
            }).disposed(by: self.disposeBag)
        
        self.addChoreBtn.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.pushToAddChore()
            }).disposed(by: self.disposeBag)
    }
}

extension DailyChoreViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let dataSourceVC = viewModel.pageVCDataSourceBehavior.value
        guard let index = dataSourceVC.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        return dataSourceVC[safe: previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let dataSourceVC = viewModel.pageVCDataSourceBehavior.value
        guard let index = dataSourceVC.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        return dataSourceVC[safe: nextIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        let dataSourceVC = viewModel.pageVCDataSourceBehavior.value
        guard let currentVC = pageViewController.viewControllers?.first,
              let currentIndex = dataSourceVC.firstIndex(of: currentVC)
        else { return }
        viewModel.didSelectCell(currentIndex)
    }
}
