//
//  CALayer+.swift
//  Dobby
//
//  Created by yongmin lee on 10/23/22.
//
import UIKit

extension CALayer {
    func makeShadow() {
        self.masksToBounds = false
        self.shadowColor = UIColor.black.cgColor
        self.shadowOpacity = 0.2
        self.shadowOffset = CGSize(width: 2, height: 2)
        self.shadowRadius = 2
    }
}
