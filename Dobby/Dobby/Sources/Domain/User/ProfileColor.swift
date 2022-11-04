//
//  ProfileColor.swift
//  Dobby
//
//  Created by yongmin lee on 11/4/22.
//

import UIKit

enum ProfileColor: Int, CaseIterable {
    case blue
    case mint
    case green
    case pink
    case purple
    case red
    case oragne
    case yellow
    case brown
    case black
}

extension ProfileColor: CustomStringConvertible {
    var description: String {
        switch self {
        case .blue: return "블루"
        case .mint: return "민트"
        case .green: return "그린"
        case .pink: return "핑크"
        case .purple: return "퍼플"
        case .red: return "레드"
        case .oragne: return "오렌지"
        case .yellow: return "옐로우"
        case .brown: return "브라운"
        case .black: return "블랙"
        }
    }
}

extension ProfileColor {
    var getUIColor: UIColor {
        switch self {
        case .blue:
            return Palette.profileBlue
        case .mint:
            return Palette.profileMint
        case .green:
            return Palette.profileMint
        case .pink:
            return Palette.profilePink
        case .purple:
            return Palette.profilePurple
        case .red:
            return Palette.profileRed
        case .oragne:
            return Palette.profileOrange
        case .yellow:
            return Palette.kakaoYellow
        case .brown:
            return Palette.profileBrown
        case .black:
            return Palette.profileBlack
        }
    }
}
