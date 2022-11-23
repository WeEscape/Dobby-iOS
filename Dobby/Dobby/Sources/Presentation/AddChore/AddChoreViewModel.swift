//
//  AddChoreViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import Foundation
import RxSwift
import RxRelay

final class AddChoreViewModel {
    
    var disposeBag: DisposeBag = .init()
    let attributeItems = BehaviorRelay<[ChoreAttribute]>(value: ChoreAttribute.allCases)
    let dateBehavior: BehaviorRelay<Date?> = .init(value: nil)
    let repeatCycleList: [ChoreRepeatCycle] = ChoreRepeatCycle.allCases
    let repeatCycleBehavior: BehaviorRelay<ChoreRepeatCycle?> = .init(value: nil)
    let myinfoBehavior: BehaviorRelay<User?> = .init(value: nil)
    let disableAddChore: PublishRelay<DisableMessage> = .init()
    let loadingPublush: PublishRelay<Bool> = .init()
    let saveBtnEnableBehavior: BehaviorRelay<Bool> = .init(value: false)
    let membersBehavior: BehaviorRelay<[String]> = .init(value: [])
    let categoriesBehavior: BehaviorRelay<[Category]> = .init(value: [])
    let choreUseCase: ChoreUseCase
    let userUseCase: UserUseCase
    let groupUseCase: GroupUseCase
    let categoryUseCase: CategoryUseCase
    
    enum DisableMessage: String {
        case NO_GROUP = "참여중인 그룹이 없습니다\n하단 탭의 더보기 > 그룹 생성 또는 다른 그룹 참여 후 등록 가능합니다."
        case FAIL_INIT = "에러 발생\n잠시후 다시 시도해주세요"
    }
    
    init(
        choreUseCase: ChoreUseCase,
        userUseCase: UserUseCase,
        groupUseCase: GroupUseCase,
        categoryUseCase: CategoryUseCase
    ) {
        self.choreUseCase = choreUseCase
        self.userUseCase = userUseCase
        self.groupUseCase = groupUseCase
        self.categoryUseCase = categoryUseCase
        BeaverLog.debug("\(String(describing: self)) init")
    }
    
    deinit {
        self.disposeBag = .init()
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
    func didTapAddBtn() {
        print("AddChoreViewModel didTapAddBtn ")
    }
    
    func didSelectDate(date: Date) {
        dateBehavior.accept(date)
    }
    
    func didSelectRepeatCycle(repeatCycle: ChoreRepeatCycle) {
        repeatCycleBehavior.accept(repeatCycle)
    }
    
    func getInitialInfo() {
        self.loadingPublush.accept(true)
        self.userUseCase.getMyInfo()
            .flatMap { [unowned self] myinfo -> Observable<Group> in
                if myinfo.groupIds == nil || myinfo.groupIds!.isEmpty {
                    return .error(CustomError.init())
                }
                self.myinfoBehavior.accept(myinfo)
                return self.groupUseCase.getGroupInfo(id: myinfo.groupIds!.last!)
            }
            .flatMap { [unowned self] group -> Observable<[Category]> in
                guard let userIds = group.members else {
                    return .error(CustomError.init())
                }
                self.membersBehavior.accept(userIds)
                return self.categoryUseCase.getCategoryList(groupId: group.groupId!)
            }
            .subscribe(onNext: { [weak self] categoryList in
                self?.loadingPublush.accept(false)
                self?.categoriesBehavior.accept(categoryList)
            }, onError: { [weak self] _ in
                self?.loadingPublush.accept(false)
                self?.disableAddChore.accept(.FAIL_INIT)
            }).disposed(by: self.disposeBag)
    }
}
