//
//  AddChoreViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import Foundation
import RxSwift
import RxRelay

enum AddChoreMessage: String {
    case NO_GROUP = "참여중인 그룹이 없습니다\n더보기에서 그룹 생성 또는 다른 그룹 참여 후 등록 가능합니다."
    case ERROR_ADD_CHORE = "에러 발생\n잠시후 다시 시도해주세요"
    case SUCCESS_ADD_CHORE = "집안일이 등록되었습니다."
}

final class AddChoreViewModel {
    
    var disposeBag: DisposeBag = .init()
    let attributeItems = BehaviorRelay<[ChoreAttribute]>(value: ChoreAttribute.allCases)
    let myinfoBehavior: BehaviorRelay<User?> = .init(value: nil)
    let addChoreMessagePublish: PublishRelay<String> = .init()
    let loadingPublush: PublishRelay<Bool> = .init()
    var saveBtnEnableBehavior: BehaviorRelay<Bool>? = .init(value: false)
    let isHiddenEndDateSelectPublish: PublishRelay<Bool> = .init()
    
    let repeatCycleList: [ChoreRepeatCycle] = ChoreRepeatCycle.allCases
    let membersBehavior: BehaviorRelay<[User]> = .init(value: [])
    let categoriesBehavior: BehaviorRelay<[Category]> = .init(value: [])
    
    var choreTitle: String?
    var choreMemo: String?
    let selectedStartDateBehavior: BehaviorRelay<Date?> = .init(value: nil)
    let selectedEndDateBehavior: BehaviorRelay<Date?> = .init(value: nil)
    let selectedRepeatCycleBehavior: BehaviorRelay<ChoreRepeatCycle?> = .init(value: nil)
    let selectedUserBehavior: BehaviorRelay<User?> = .init(value: nil)
    let selectedCategoryBehavior: BehaviorRelay<Category?> = .init(value: nil)
    
    let choreUseCase: ChoreUseCase
    let userUseCase: UserUseCase
    let groupUseCase: GroupUseCase
    let categoryUseCase: CategoryUseCase
    
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
              let excuteAt = self.selectedStartDateBehavior.value,
              let ownerId = self.selectedUserBehavior.value?.userId
        else {
            self.loadingPublush.accept(false)
            return
        }
        let endAt = self.selectedEndDateBehavior.value ?? Date().calculateDiffDate(diff: 60)!
        let notice = 1
        let memo = self.choreMemo?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let newChore = Chore(
            choreId: "", title: title, categoryId: categoryId, repeatCycle: repeayCycle.rawValue,
            noticeEnable: notice, executeAt: excuteAt.toStringWithFormat(),
            endAt: endAt.toStringWithFormat(), ownerList: nil, memo: memo
        )
        self.choreUseCase.postChore(chore: newChore, ownerList: [ownerId])
            .subscribe(onNext: { [weak self] _ in
                self?.loadingPublush.accept(false)
                self?.saveBtnEnableBehavior = nil
                self?.addChoreMessagePublish.accept(AddChoreMessage.SUCCESS_ADD_CHORE.rawValue)
            }, onError: { [weak self] _ in
                self?.loadingPublush.accept(false)
                self?.saveBtnEnableBehavior = nil
                self?.addChoreMessagePublish.accept(AddChoreMessage.ERROR_ADD_CHORE.rawValue)
            }).disposed(by: self.disposeBag)
    }
    
    func didSelectDate(date: Date, attribute: ChoreAttribute) {
        if attribute == .startDate {
            selectedStartDateBehavior.accept(date)
            if let currentEndDate = selectedEndDateBehavior.value,
               currentEndDate < date {
                selectedEndDateBehavior.accept(nil)
            }
        } else if attribute == .endDate {
            if let currentStartDate = selectedStartDateBehavior.value,
               date < currentStartDate {
                selectedEndDateBehavior.accept(nil)
            }
            selectedEndDateBehavior.accept(date)
        }
        validateSaveBtn()
    }
    
    func didSelectRepeatCycle(repeatCycle: ChoreRepeatCycle) {
        selectedRepeatCycleBehavior.accept(repeatCycle)
        validateSaveBtn()
        isHiddenEndDateSelect()
    }
    
    func didSelectCategory(category: Category) {
        selectedCategoryBehavior.accept(category)
        validateSaveBtn()
    }
    
    func didSelectUser(user: User) {
        selectedUserBehavior.accept(user)
        validateSaveBtn()
    }
    
    func isHiddenEndDateSelect() {
        if let cycle = selectedRepeatCycleBehavior.value,
           cycle == .off {
            isHiddenEndDateSelectPublish.accept(true)
        } else {
            isHiddenEndDateSelectPublish.accept(false)
        }
    }
    
    func validateSaveBtn() {
        if let cycle = selectedRepeatCycleBehavior.value,
           cycle == .off,
           selectedStartDateBehavior.value != nil,
           selectedCategoryBehavior.value != nil,
           selectedUserBehavior.value != nil,
           let title = choreTitle,
           title.isEmpty == false {
            self.saveBtnEnableBehavior?.accept(true)
        } else if let cycle = selectedRepeatCycleBehavior.value,
                  cycle != .off,
                  selectedStartDateBehavior.value != nil,
                  selectedEndDateBehavior.value != nil,
                  selectedCategoryBehavior.value != nil,
                  selectedUserBehavior.value != nil,
                  let title = choreTitle,
                  title.isEmpty == false {
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
                self?.addChoreMessagePublish.accept(err.localizedDescription)
                self?.saveBtnEnableBehavior = nil
            }).disposed(by: self.disposeBag)
    }
}
