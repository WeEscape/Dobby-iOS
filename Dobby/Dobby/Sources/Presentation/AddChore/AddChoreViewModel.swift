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
    let myinfoBehavior: BehaviorRelay<User?> = .init(value: nil)
    let disableAddChore: PublishRelay<DisableMessage> = .init()
    let loadingPublush: PublishRelay<Bool> = .init()
    var saveBtnEnableBehavior: BehaviorRelay<Bool>? = .init(value: false)
    
    let repeatCycleList: [ChoreRepeatCycle] = ChoreRepeatCycle.allCases
    let membersBehavior: BehaviorRelay<[User]> = .init(value: [])
    let categoriesBehavior: BehaviorRelay<[Category]> = .init(value: [])
    
    let selectedDateBehavior: BehaviorRelay<Date?> = .init(value: nil)
    let selectedRepeatCycleBehavior: BehaviorRelay<ChoreRepeatCycle?> = .init(value: nil)
    let selectedUserBehavior: BehaviorRelay<User?> = .init(value: nil)
    let selectedCategoryBehavior: BehaviorRelay<Category?> = .init(value: nil)
    
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
        selectedDateBehavior.accept(date)
        enableSaveBtn()
    }
    
    func didSelectRepeatCycle(repeatCycle: ChoreRepeatCycle) {
        selectedRepeatCycleBehavior.accept(repeatCycle)
        enableSaveBtn()
    }
    
    func didSelectCategory(category: Category) {
        selectedCategoryBehavior.accept(category)
        enableSaveBtn()
    }
    
    func didSelectUser(user: User) {
        selectedUserBehavior.accept(user)
        enableSaveBtn()
    }
    
    func enableSaveBtn() {
        if selectedDateBehavior.value != nil,
           selectedRepeatCycleBehavior.value != nil,
           selectedCategoryBehavior.value != nil,
           selectedUserBehavior.value != nil {
            self.saveBtnEnableBehavior?.accept(true)
        } else {
            self.saveBtnEnableBehavior?.accept(false)
        }
    }
    
    func getInitialInfo() {
        self.loadingPublush.accept(true)
        self.userUseCase.getMyInfo()
            .flatMap { [unowned self] myinfo -> Observable<Group> in
                guard let myGroupId = myinfo.groupList?.last?.groupId else {
                    return .error(CustomError.init())
                }
                self.myinfoBehavior.accept(myinfo)
                return self.groupUseCase.getGroupInfo(id: myGroupId)
            }
            .flatMap { [unowned self] group -> Observable<[Category]> in
                guard let memberList = group.memberList else {
                    return .error(CustomError.init())
                }
                self.membersBehavior.accept(memberList)
                return self.categoryUseCase.getCategoryList(groupId: group.groupId!)
            }
            .subscribe(onNext: { [weak self] categoryList in
                self?.loadingPublush.accept(false)
                self?.categoriesBehavior.accept(categoryList)
            }, onError: { [weak self] _ in
                self?.loadingPublush.accept(false)
                self?.disableAddChore.accept(.FAIL_INIT)
                self?.saveBtnEnableBehavior = nil
            }).disposed(by: self.disposeBag)
    }
}
