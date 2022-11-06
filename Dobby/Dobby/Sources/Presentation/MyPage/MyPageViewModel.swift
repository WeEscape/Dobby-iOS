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
    let authUseCase: AuthUseCase
    let alertPublish: PublishRelay<UIAlertController> = .init()
    let logoutPublish: PublishRelay<Void> = .init()
    let resignPublish: PublishRelay<Void> = .init()
    
    init(
        authUseCase: AuthUseCase
    ) {
        self.authUseCase = authUseCase
        BeaverLog.debug("\(String(describing: self)) init")
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
    
    func requestLogout() {
        self.authUseCase.logout()
            .subscribe(onNext: { [weak self] _ in
                self?.logoutPublish.accept(())
            }).disposed(by: self.disposeBag)
    }
    
    func requestResign() {
        // use case resign
        self.logoutPublish.accept(())
    }
}
