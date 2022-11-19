//
//  MyPageViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 10/31/22.
//

import UIKit
import RxSwift
import RxRelay

final class MyPageViewModel {
    
    var disposeBag: DisposeBag = .init()
    let alertPublish: PublishRelay<UIAlertController> = .init()
    let logoutPublish: PublishRelay<Void> = .init()
    let resignPublish: PublishRelay<Void> = .init()
    let myInfoBehavior: BehaviorRelay<User?> = .init(value: nil)
    let myGroupIdBehavior: BehaviorRelay<String?> = .init(value: nil)
    let inviteCodePublish: PublishRelay<String?> = .init()
    let loadingPublish: PublishRelay<Bool> = .init()
    let authUseCase: AuthUseCase
    let userUserCase: UserUseCase
    let groupUseCase: GroupUseCase
    
    init(
        authUseCase: AuthUseCase,
        userUserCase: UserUseCase,
        groupUseCase: GroupUseCase
    ) {
        self.authUseCase = authUseCase
        self.userUserCase = userUserCase
        self.groupUseCase = groupUseCase
    }
    
    deinit {
        self.disposeBag = .init()
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
    func didTapLogout() {
        let alertVC = UIAlertController(
            title: "알림",
            message: "\n로그아웃을 하시겠습니까?",
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.requestLogout()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        [confirmAction, cancelAction].forEach { action in
            alertVC.addAction(action)
        }
        alertPublish.accept(alertVC)
    }
    
    func didTapResign() {
        let alertVC = UIAlertController(
            title: "알림",
            message: "\n정말 회원탈퇴를 하시겠습니까?",
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.requestResign()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        [confirmAction, cancelAction].forEach { action in
            alertVC.addAction(action)
        }
        alertPublish.accept(alertVC)
    }
    
    func didTapLeaveGroup() {
        let alertVC = UIAlertController(
            title: "알림",
            message: "\n정말 그룹을 나가시겠습니까?",
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.leaveGroup()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        [confirmAction, cancelAction].forEach { action in
            alertVC.addAction(action)
        }
        alertPublish.accept(alertVC)
    }
    
    func requestLogout() {
        self.authUseCase.logout()
            .subscribe(onNext: { [weak self] _ in
                self?.authUseCase.removeToken(tokenOption: [.accessToken, .refreshToken])
                self?.logoutPublish.accept(())
            }).disposed(by: self.disposeBag)
    }
    
    func requestResign() {
        self.authUseCase.resign()
            .subscribe(onNext: { [weak self] _ in
                self?.authUseCase.removeToken(tokenOption: [.accessToken, .refreshToken])
                self?.resignPublish.accept(())
            }).disposed(by: self.disposeBag)
    }
    
    func getMyInfo() {
        self.userUserCase.getMyInfo()
            .subscribe(onNext: { [weak self] myinfo in
                self?.myInfoBehavior.accept(myinfo)
                self?.myGroupIdBehavior.accept(myinfo.groupIds?.first)
            }).disposed(by: self.disposeBag)
    }
    
    func getGroupInfo(groupId: String?) {
        guard let groupId = groupId else {
            self.inviteCodePublish.accept(nil)
            return
        }
        self.groupUseCase.getGroupInfo(id: groupId)
            .subscribe(onNext: { [weak self] group in
                self?.inviteCodePublish.accept(group.inviteCode)
            }).disposed(by: self.disposeBag)
    }
    
    func createGroup() {
        self.loadingPublish.accept(true)
        self.groupUseCase.createGroup()
            .subscribe(onNext: { [weak self] group in
                self?.myGroupIdBehavior.accept(group.groupId)
                self?.inviteCodePublish.accept(group.inviteCode)
                self?.loadingPublish.accept(false)
            }, onError: { [weak self] _ in
                self?.loadingPublish.accept(false)
            }).disposed(by: self.disposeBag)
    }
    
    func leaveGroup() {
        guard let myGroupId = myGroupIdBehavior.value else {
            return
        }
        self.loadingPublish.accept(true)
        self.groupUseCase.leaveGroup(id: myGroupId)
            .subscribe(onNext: { [weak self] _ in
                self?.myGroupIdBehavior.accept(nil)
                self?.loadingPublish.accept(false)
            }, onError: { [weak self] _ in
                self?.loadingPublish.accept(false)
            }).disposed(by: self.disposeBag)
    }
}
