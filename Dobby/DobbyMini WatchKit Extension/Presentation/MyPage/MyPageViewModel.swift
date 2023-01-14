//
//  MyPageViewModel.swift
//  DobbyMini WatchKit Extension
//
//  Created by yongmin lee on 1/14/23.
//

import Foundation
import RxSwift

class MyPageViewModel: ObservableObject {
    
    var disposeBag = DisposeBag()
    let userUseCase: UserUseCase
    let groupUseCase: GroupUseCase
    
    @Published var profileUrl = ""
    @Published var userName = ""
    @Published var groupCode = ""
    
    init(
        userUseCase: UserUseCase,
        groupUseCase: GroupUseCase
    ) {
        self.userUseCase = userUseCase
        self.groupUseCase = groupUseCase
    }
    
    func getMyInfo() {
        self.userUseCase.removeUserInfoInLocalStorage()
        self.userUseCase.getMyInfo()
            .flatMapLatest { [weak self] myinfo -> Observable<Group> in
                guard let self = self,
                      let groupId = myinfo.groupList?.last?.groupId
                else {return .error(CustomError.init())}
                self.userUseCase.saveUserInfoInLocalStorage(user: myinfo)
                self.profileUrl = myinfo.profileUrl ?? ""
                self.userName = myinfo.name ?? ""
                return self.groupUseCase.getGroupInfo(id: groupId)
            }
            .subscribe(onNext: { [weak self] groupInfo in
                if let inviteCode = groupInfo.inviteCode,
                inviteCode.isEmpty == false {
                    self?.groupCode = "그룹코드 : " + inviteCode
                } else {
                    self?.groupCode = ""
                }
            }, onError: { _ in
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .shouldReLogin, object: nil)
                }
            }).disposed(by: self.disposeBag)
    }
}
