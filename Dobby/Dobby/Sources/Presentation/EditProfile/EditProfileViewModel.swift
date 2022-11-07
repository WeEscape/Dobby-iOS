//
//  EditProfileViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 11/1/22.
//

import Foundation
import RxSwift
import RxRelay

final class EditProfileViewModel {
    
    var disposeBag: DisposeBag = .init()
    let profileColorBehavior: BehaviorRelay<ProfileColor?> = .init(value: nil)
    let colorList = ProfileColor.allCases
    let acitonSheetPublish: PublishRelay<UIAlertController> = .init()
    let emojiModalPublishh: PublishRelay<Void> = .init()
    
    init() {
        BeaverLog.debug("\(String(describing: self)) init")
        profileColorBehavior.accept(.purple)
    }
    
    deinit {
        self.disposeBag = .init()
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
    func didSelectColor(_ color: ProfileColor) {
        profileColorBehavior.accept(color)
    }
    
    func didTapProfilePhotoEdit() {
        let actionSheetVC = UIAlertController(
            title: "프로필 사진 설정",
            message: nil,
            preferredStyle: .actionSheet
        )
        let emojiAction = UIAlertAction(title: "이모티콘 선택", style: .default) { [weak self] _ in
            self?.emojiModalPublishh.accept(())
        }
        let defaultProfileAction = UIAlertAction(title: "기본 이미지로 변경", style: .default) { [weak self] _ in
            self?.setDefaultProfile()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [emojiAction, defaultProfileAction, cancelAction].forEach { action in
            actionSheetVC.addAction(action)
        }
        self.acitonSheetPublish.accept(actionSheetVC)
    }
    
    func setDefaultProfile() {
        print("Debug : set Default Profile")
    }
}
