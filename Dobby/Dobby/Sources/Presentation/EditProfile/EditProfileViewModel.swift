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
    let profileColorRelay: PublishRelay<ProfileColor> = .init()
    
    init() {
        BeaverLog.debug("\(String(describing: self)) init")
        profileColorRelay.accept(.purple)
    }
    
    deinit {
        self.disposeBag = .init()
        BeaverLog.debug("\(String(describing: self)) deinit")
    }
    
    func didSelectColor(_ color: ProfileColor){
        profileColorRelay.accept(color)
    }
}
