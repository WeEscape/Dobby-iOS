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
    let toastMessagePublish: PublishRelay<String> = .init()
    let errorMessagPublish: PublishRelay<String> = .init()
    let alarmPulish: PublishRelay<(Bool, Date)> = .init()
    
    let authUseCase: AuthUseCase
    let userUserCase: UserUseCase
    let groupUseCase: GroupUseCase
    let categoryUseCase: CategoryUseCase
    let alarmUseCase: AlarmUseCase
    
    init(
        authUseCase: AuthUseCase,
        userUserCase: UserUseCase,
        groupUseCase: GroupUseCase,
        categoryUseCase: CategoryUseCase,
        alarmUseCase: AlarmUseCase
    ) {
        self.authUseCase = authUseCase
        self.userUserCase = userUserCase
        self.groupUseCase = groupUseCase
        self.categoryUseCase = categoryUseCase
        self.alarmUseCase = alarmUseCase
    }
    
    deinit {
        self.disposeBag = .init()
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
    func didTapLogout() {
        let alertVC = self.alertFactory(
            message: "로그아웃을 하시겠습니까?",
            confirmAction: UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                self?.requestLogout()
            }
        )
        alertPublish.accept(alertVC)
    }
    
    func didTapResign() {
        let alertVC = self.alertFactory(
            message: "정말 회원탈퇴를 하시겠습니까?",
            confirmAction: UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                self?.requestResign()
            }
        )
        alertPublish.accept(alertVC)
    }
    
    func didTapLeaveGroup() {
        let alertVC = self.alertFactory(
            message: "그룹을 나가시겠습니까?",
            confirmAction: UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                self?.leaveGroup()
            }
        )
        alertPublish.accept(alertVC)
    }
    
    func didTapJoinGroup() {
        let alertVC = UIAlertController(
            title: "알림",
            message: "그룹코드를 입력하세요",
            preferredStyle: .alert
        )
        alertVC.addTextField { textfield in
            textfield.keyboardType = .numberPad
        }
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.joinGroup(groupId: alertVC.textFields?.first?.text)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        [confirmAction, cancelAction].forEach { action in
            alertVC.addAction(action)
        }
        alertPublish.accept(alertVC)
    }
    
    func didLongPressGroupLabel(text: String) {
        let components = text.components(separatedBy: "그룹코드: ")
        if components.count > 1,
           let inviteCode = components[safe: 1] {
            UIPasteboard.general.string = inviteCode
            toastMessagePublish.accept("그룹코드가 클립보드에 복사되었습니다.")
        }
    }
    
    func alertFactory(message: String?, confirmAction: UIAlertAction) -> UIAlertController {
        let alertVC = UIAlertController(
            title: "알림",
            message: message,
            preferredStyle: .alert
        )
        let confirmAction = confirmAction
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        [confirmAction, cancelAction].forEach { action in
            alertVC.addAction(action)
        }
        return alertVC
    }
    
    func requestLogout() {
        self.authUseCase.logout()
            .subscribe(onNext: {  [weak self] _ in
                self?.userUserCase.removeUserInfoInLocalStorate()
                self?.authUseCase.removeToken(tokenOption: [.accessToken, .refreshToken])
                self?.logoutPublish.accept(())
            }, onError: { [weak self] err in
                self?.errorMessagPublish.accept(err.localizedDescription)
            }).disposed(by: self.disposeBag)
    }
    
    func requestResign() {
        self.authUseCase.resign()
            .subscribe(onNext: { [weak self] _ in
                self?.userUserCase.removeUserInfoInLocalStorate()
                self?.authUseCase.removeToken(tokenOption: [.accessToken, .refreshToken])
                self?.resignPublish.accept(())
            }, onError: { [weak self] err in
                self?.errorMessagPublish.accept(err.localizedDescription)
            }).disposed(by: self.disposeBag)
    }
    
    func getMyInfo() {
        self.loadingPublish.accept(true)
        self.userUserCase.getMyInfo()
            .subscribe(onNext: { [weak self] myinfo in
                self?.myInfoBehavior.accept(myinfo)
                self?.myGroupIdBehavior.accept(myinfo.groupList?.last?.groupId)
            }, onError: { [weak self] err in
                self?.loadingPublish.accept(false)
                self?.errorMessagPublish.accept(err.localizedDescription)
            }).disposed(by: self.disposeBag)
    }
    
    func getGroupInfo(groupId: String?) {
        guard let groupId = groupId else {
            self.inviteCodePublish.accept(nil)
            self.loadingPublish.accept(false)
            return
        }
        self.groupUseCase.getGroupInfo(id: groupId)
            .subscribe(onNext: { [weak self] group in
                self?.inviteCodePublish.accept(group.inviteCode)
                self?.loadingPublish.accept(false)
            }, onError: { [weak self] err in
                self?.loadingPublish.accept(false)
                self?.errorMessagPublish.accept(err.localizedDescription)
            }).disposed(by: self.disposeBag)
    }
    
    func createGroup() {
        self.loadingPublish.accept(true)
        self.groupUseCase.createGroup()
            .subscribe(onNext: { [weak self] group in
                self?.userUserCase.removeUserInfoInLocalStorate()
                self?.inviteCodePublish.accept(group.inviteCode)
                self?.myGroupIdBehavior.accept(group.groupId)
                self?.loadingPublish.accept(false)
            }, onError: { [weak self] err in
                self?.loadingPublish.accept(false)
                self?.errorMessagPublish.accept(err.localizedDescription)
            }).disposed(by: self.disposeBag)
    }
    
    func leaveGroup() {
        guard let myGroupId = myGroupIdBehavior.value else {
            return
        }
        self.loadingPublish.accept(true)
        self.groupUseCase.leaveGroup(id: myGroupId)
            .subscribe(onNext: { [weak self] _ in
                self?.userUserCase.removeUserInfoInLocalStorate()
                self?.myGroupIdBehavior.accept(nil)
                self?.loadingPublish.accept(false)
            }, onError: { [weak self] err in
                self?.loadingPublish.accept(false)
                self?.errorMessagPublish.accept(err.localizedDescription)
            }).disposed(by: self.disposeBag)
    }
    
    func joinGroup(groupId: String?) {
        guard let groupId = groupId else {return}
        self.loadingPublish.accept(true)
        self.groupUseCase.joinGroup(inviteCode: groupId)
            .subscribe(onNext: { [weak self] group in
                self?.userUserCase.removeUserInfoInLocalStorate()
                self?.myGroupIdBehavior.accept(group.groupId)
                self?.inviteCodePublish.accept(group.inviteCode)
                self?.loadingPublish.accept(false)
            }, onError: { [weak self] _ in
                self?.loadingPublish.accept(false)
                self?.toastMessagePublish.accept("그룹코드를 확인 해주세요")
            }).disposed(by: self.disposeBag)
    }
    
    func getAlarmInfo() {
        let alarmInfo = self.alarmUseCase.getAlarmInfo()
        self.alarmPulish.accept(alarmInfo)
    }
    
    func setAlarmInfo(isOn: Bool, time: Date) {
        self.alarmUseCase.setAlarmInfo(isOn: isOn, time: time)
    }
}
