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
            return "더보기"
        }
    }
}

extension MainTab {
    var icon: UIImage? {
        switch self {
        case .dailyChore:
            return UIImage(named: "daily_chore")?.withRenderingMode(.alwaysOriginal)
        case .weeklyChore:
            return UIImage(named: "weekly_chore")?.withRenderingMode(.alwaysOriginal)
        case .addChore:
            return UIImage(named: "icon_add")?.withRenderingMode(.alwaysOriginal)
        case .monthlyChore:
            return UIImage(named: "monthly_chore")?.withRenderingMode(.alwaysOriginal)
        case .mypage:
            return UIImage(named: "icon_ ellipsis")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    var selectedIcon: UIImage? {
        switch self {
        case .dailyChore:
            return UIImage(named: "daily_chore_active")?.withRenderingMode(.alwaysOriginal)
        case .weeklyChore:
            return UIImage(named: "weekly_chore_active")?.withRenderingMode(.alwaysOriginal)
        case .addChore:
            return UIImage(named: "icon_add")?.withRenderingMode(.alwaysOriginal)
        case .monthlyChore:
            return UIImage(named: "monthly_chore_active")?.withRenderingMode(.alwaysOriginal)
        case .mypage:
            return UIImage(named: "icon_ ellipsis_active")?.withRenderingMode(.alwaysOriginal)
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
