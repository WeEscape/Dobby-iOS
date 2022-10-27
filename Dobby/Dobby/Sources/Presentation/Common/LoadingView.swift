//
//  LoadingView.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//

import UIKit
import Lottie

final class LoadingIndicator: UIView {
    var isLoading = false {
        didSet {
            guard oldValue != isLoading else { return }
            isLoading ? start() : stop()
        }
    }
    
    private let animationView: AnimationView = {
        let ani = AnimationView()
        ani.animation = Animation.named("loading")
        return ani
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.isHidden = true
        self.backgroundColor = .gray.withAlphaComponent(0.2)
        self.addSubview(self.animationView)
        self.animationView.snp.makeConstraints {
            $0.width.height.equalTo(150)
            $0.center.equalToSuperview()
        }
    }
    
    func start() {
        self.isHidden = false
        self.animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop, completion: nil)
        self.isLoading = true
    }
    
    func stop() {
        self.isHidden = true
        self.animationView.stop()
        self.isLoading = false
    }
    
}
