//
//  DobbyFont.swift
//  Dobby
//
//  Created by yongmin lee on 10/20/22.
//
// http://iosfonts.com/

import UIKit

enum DobbyFont {
    case avenirBlack(size: CGFloat)
    case avenirMedium(size: CGFloat)
    case avenirLight(size: CGFloat)
    
    var getFont: UIFont? {
        switch self {
        case .avenirBlack(let size):
            return UIFont(name: "Avenir-Black", size: size)
        case .avenirMedium(let size):
            return UIFont(name: "Avenir-Medium", size: size)
        case .avenirLight(let size):
            return UIFont(name: "Avenir-Light", size: size)
        }
    }
}
