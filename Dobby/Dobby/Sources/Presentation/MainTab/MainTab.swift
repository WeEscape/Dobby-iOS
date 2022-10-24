//
//  MainTab.swift
//  Dobby
//
//  Created by yongmin lee on 10/17/22.
//

import UIKit

enum MainTab: Int, CaseIterable {
    case dailyChore
    case weeklyChore
    case addChore
    case monthlyChore
    case mypage
}

extension MainTab: CustomStringConvertible {
    var description: String {
        switch self {
        case .dailyChore:
            return "일간"
        case .weeklyChore:
            return "주간"
        case .addChore:
            return "등록"
        case .monthlyChore:
            return "월간"
        case .mypage:
            return "마이페이지"
        }
    }
}

extension MainTab {
    var icon: UIImage? {
        switch self {
        case .dailyChore:
            return UIImage(systemName: "play")
        case .weeklyChore:
            return UIImage(systemName: "pause")
        case .addChore:
            return UIImage(named: "icon_add")?.withRenderingMode(.alwaysOriginal)
        case .monthlyChore:
            return UIImage(systemName: "cloud")
        case .mypage:
            return UIImage(systemName: "person")
        }
    }
    
    var selectedIcon: UIImage? {
        switch self {
        case .dailyChore:
            return UIImage(systemName: "play.fill")
        case .weeklyChore:
            return UIImage(systemName: "pause.fill")
        case .addChore:
            return UIImage(named: "icon_add")?.withRenderingMode(.alwaysOriginal)
        case .monthlyChore:
            return UIImage(systemName: "cloud.fill")
        case .mypage:
            return UIImage(systemName: "person.fill")
        }
    }
}

extension MainTab {
    func getTabBarItem() -> UITabBarItem {
        return UITabBarItem(
            title: description,
            image: icon,
            selectedImage: selectedIcon
        )
    }
}
