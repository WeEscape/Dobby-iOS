//
//  ChoreViewModel.swift
//  DobbyMini Watch App
//
//  Created by yongmin lee on 12/25/22.
//

import Foundation
import RxSwift

class ChoreViewModel: ObservableObject {
    
    @Published var currentDate: Date = Date()
    @Published var currentChoreList: [Chore] = []
    
    var disposeBag = DisposeBag()
    let choreUseCase: ChoreUseCase
    let userUseCase: UserUseCase
    
    init(
        choreUseCase: ChoreUseCase,
        userUseCase: UserUseCase
    ) {
        self.choreUseCase = choreUseCase
        self.userUseCase = userUseCase
    }
    
    func getChoreList(of date: Date) {
        self.userUseCase.getMyInfo()
            .flatMapLatest { [weak self] myinfo -> Observable<[Chore]> in
                guard let self = self,
                      let userId = myinfo.userId,
                      let groupId = myinfo.groupList?.last?.groupId
                else {return .error(CustomError.init())}
                self.userUseCase.saveUserInfoInLocalStorage(user: myinfo)
                return self.choreUseCase.getChores(
                    userId: userId,
                    groupId: groupId,
                    date: date,
                    periodical: .daily
                )
            }
            .subscribe(onNext: { [weak self] choreList in
                guard let self = self else {return}
                self.currentChoreList = choreList
                self.currentDate = date
            }, onError: { [weak self] _ in
                self?.userUseCase.removeUserInfoInLocalStorage()
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .shouldReLogin, object: nil)
                }
            }).disposed(by: self.disposeBag)
    }
    
    func didTapEndToggle(_ chore: Chore) {
        self.userUseCase.getMyInfo()
            .flatMapLatest { [weak self] myinfo -> Observable<Void> in
                guard let self = self,
                      let userId = myinfo.userId,
                      let isEnd = chore.ownerList?.filter({ owner in
                          owner.userId == userId
                      }).last?.isEnd
                else {return .error(CustomError.init())}
                return self.choreUseCase.finishChore(
                    chore: chore,
                    userId: userId,
                    isEnd: !(isEnd == 1)
                )
            }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.getChoreList(of: self.currentDate)
            }, onError: { [weak self] _ in
                self?.userUseCase.removeUserInfoInLocalStorage()
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .shouldReLogin, object: nil)
                }
            }).disposed(by: self.disposeBag)
    }
    
    func didTapDelete(_ chore: Chore) {
        self.choreUseCase.deleteChore(chore: chore)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.getChoreList(of: self.currentDate)
            }, onError: { _ in
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .shouldReLogin, object: nil)
                }
            }).disposed(by: self.disposeBag)
    }
}
