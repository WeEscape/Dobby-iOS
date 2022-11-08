//
//  LoadingIndicatorView.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit
import Lottie
import Toast_Swift

final class LoadingIndicatorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .gray.withAlphaComponent(0.2)
        self.isUserInteractionEnabled = true
        self.isExclusiveTouch = true
        self.makeToastActivity(.center)
    }
}
