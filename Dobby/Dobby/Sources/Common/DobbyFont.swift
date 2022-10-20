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
    
    var getFont: UIFont? {
        switch self {
        case .avenirBlack(let size):
            return UIFont(name: "Avenir-Black", size: size)
        }
    }
}
