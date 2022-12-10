//
//  WeeklyChoreViewModel.swift
//  Dobby
//
//  Created by yongmin lee on 12/10/22.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit

class WeeklyChoreViewModel {
    
    // MARK: property
    var disposBag: DisposeBag = .init()
    let loadingPublish: PublishRelay<Bool> = .init()
    
}
