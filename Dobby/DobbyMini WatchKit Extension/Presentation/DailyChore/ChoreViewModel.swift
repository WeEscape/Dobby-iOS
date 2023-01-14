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
        currentDate = date
        self.userUseCase.getMyInfo()
            .flatMap { [weak self] myinfo -> Observable<[Chore]> in
                guard let self = self,
                      let userId = myinfo.userId,
                      let groupId = myinfo.groupList?.last?.groupId
                else {return .error(CustomError.init())}
                return self.choreUseCase.getChores(
                    userId: userId,
                    groupId: groupId,
                    date: self.currentDate,
                    periodical: .daily
                )
            }
            .subscribe(onNext: { [weak self] choreList in
                guard let self = self else {return}
                self.currentChoreList = choreList
            }, onError: { err in
                // 앱 재로그인 안내
            }).disposed(by: self.disposeBag)
    }
    
    func didTapEndToggle(_ chore: Chore) {
        print("debug : didTapEndToggle -> \(chore.title)")
    }
    
    func didTapDelete(_ chore: Chore) {
        print("debug : didTapDelete -> \(chore.title)")
    }
}
