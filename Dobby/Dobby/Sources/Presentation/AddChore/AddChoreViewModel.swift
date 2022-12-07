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
    let addChoreMsgPublish: PublishRelay<AddChoreMessage> = .init()
    let loadingPublush: PublishRelay<Bool> = .init()
    var saveBtnEnableBehavior: BehaviorRelay<Bool>? = .init(value: false)
    
    let repeatCycleList: [ChoreRepeatCycle] = ChoreRepeatCycle.allCases
    let membersBehavior: BehaviorRelay<[User]> = .init(value: [])
    let categoriesBehavior: BehaviorRelay<[Category]> = .init(value: [])
    
    var choreTitle: String?
    var choreMemo: String?
    let selectedDateBehavior: BehaviorRelay<Date?> = .init(value: nil)
    let selectedRepeatCycleBehavior: BehaviorRelay<ChoreRepeatCycle?> = .init(value: nil)
    let selectedUserBehavior: BehaviorRelay<User?> = .init(value: nil)
    let selectedCategoryBehavior: BehaviorRelay<Category?> = .init(value: nil)
    
    let choreUseCase: ChoreUseCase
    let userUseCase: UserUseCase
    let groupUseCase: GroupUseCase
    let categoryUseCase: CategoryUseCase
    
    enum AddChoreMessage: String {
        case NO_GROUP = "참여중인 그룹이 없습니다\n더보기에서 그룹 생성 또는 다른 그룹 참여 후 등록 가능합니다."
        case ERROR_ADD_CHORE = "에러 발생\n잠시후 다시 시도해주세요"
        case SUCCESS_ADD_CHORE = "집안일이 등록되었습니다."
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
        self.loadingPublush.accept(true)
        self.saveBtnEnableBehavior?.accept(false)
        guard let categoryId = self.selectedCategoryBehavior.value?.categoryId,
              let title = self.choreTitle,
              let repeayCycle = self.selectedRepeatCycleBehavior.value,
              let excuteAt = self.selectedDateBehavior.value,
              let endAt = excuteAt.calculateDiffDate(diff: 365),
              let ownerId = self.selectedUserBehavior.value?.userId
        else {
            self.loadingPublush.accept(false)
            return
        }
        let notice = 1
        let memo = self.choreMemo ?? ""
        let newChore = Chore(
            choreId: "", title: title, categoryId: categoryId, repeatCycle: repeayCycle.rawValue,
            noticeEnable: notice, executeAt: excuteAt.toStringWithoutTime(),
            endAt: endAt.toStringWithoutTime(), ownerList: nil, memo: memo
        )
        self.choreUseCase.postChore(chore: newChore, ownerList: [ownerId])
            .subscribe(onNext: { [weak self] _ in
                self?.loadingPublush.accept(false)
                self?.saveBtnEnableBehavior = nil
                self?.addChoreMsgPublish.accept(.SUCCESS_ADD_CHORE)
            }, onError: { [weak self] _ in
                self?.loadingPublush.accept(false)
                self?.saveBtnEnableBehavior = nil
                self?.addChoreMsgPublish.accept(.ERROR_ADD_CHORE)
            }).disposed(by: self.disposeBag)
    }
    
    func didSelectDate(date: Date) {
        selectedDateBehavior.accept(date)
        validateSaveBtn()
    }
    
    func didSelectRepeatCycle(repeatCycle: ChoreRepeatCycle) {
        selectedRepeatCycleBehavior.accept(repeatCycle)
        validateSaveBtn()
    }
    
    func didSelectCategory(category: Category) {
        selectedCategoryBehavior.accept(category)
        validateSaveBtn()
    }
    
    func didSelectUser(user: User) {
        selectedUserBehavior.accept(user)
        validateSaveBtn()
    }
    
    func validateSaveBtn() {
        if selectedDateBehavior.value != nil,
           selectedRepeatCycleBehavior.value != nil,
           selectedCategoryBehavior.value != nil,
           selectedUserBehavior.value != nil,
           choreTitle.isNilOrEmpty() == false {
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
                    return .error(CustomError.init(
                        memo: AddChoreMessage.NO_GROUP.rawValue
                    ))
                }
                self.myinfoBehavior.accept(myinfo)
                return self.groupUseCase.getGroupInfo(id: myGroupId)
            }
            .flatMap { [unowned self] group -> Observable<[Category]> in
                guard let memberList = group.memberList else {
                    return .error(CustomError.init(
                        memo: AddChoreMessage.NO_GROUP.rawValue
                    ))
                }
                self.membersBehavior.accept(memberList)
                return self.categoryUseCase.getCategoryList(groupId: group.groupId!)
            }
            .subscribe(onNext: { [weak self] categoryList in
                self?.loadingPublush.accept(false)
                self?.categoriesBehavior.accept(categoryList)
            }, onError: { [weak self] err in
                self?.loadingPublush.accept(false)
                self?.addChoreMsgPublish.accept(
                    AddChoreMessage(rawValue: err.localizedDescription) ?? .ERROR_ADD_CHORE
                )
                self?.saveBtnEnableBehavior = nil
            }).disposed(by: self.disposeBag)
    }
}
