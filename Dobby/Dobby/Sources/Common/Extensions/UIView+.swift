//
//  UIView+.swift
//  Dobby
//
//  Created by yongmin lee on 11/1/22.
//

import UIKit
import SnapKit

extension UIView {
    
    func makeLineViewConstraints(
        leftInset: CGFloat = 0,
        rightInset: CGFloat = 0,
        height: CGFloat = 1,
        topEqualTo: ConstraintRelatableTarget? = nil,
        topOffset: CGFloat = 0
    ) {
        guard self.superview != nil else {return}
        
        if let topEqualTo = topEqualTo {
            self.snp.makeConstraints {
                $0.left.equalToSuperview().inset(leftInset)
                $0.right.equalToSuperview().inset(rightInset)
                $0.height.equalTo(height)
                $0.top.equalTo(topEqualTo).offset(topOffset)
            }
        } else {
            self.snp.makeConstraints {
                $0.left.equalToSuperview().inset(leftInset)
                $0.right.equalToSuperview().inset(rightInset)
                $0.height.equalTo(height)
            }
        }
    }
}
