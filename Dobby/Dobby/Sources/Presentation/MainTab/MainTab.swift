//
//  MainTab.swift
//  Dobby
//
//  Created by yongmin lee on 10/17/22.
//

import UIKit

enum MainTab: Int, CaseIterable {
    case dailyTask
    case weeklyTask
    case addTask
    case monthlyTask
    case mypage
}

extension MainTab: CustomStringConvertible {
    var description: String {
        switch self {
        case .dailyTask:
            return "일간"
        case .weeklyTask:
            return "주간"
        case .addTask:
            return "등록"
        case .monthlyTask:
            return "월간"
        case .mypage:
            return "마이페이지"
        }
    }
}

extension MainTab {
    var icon: UIImage? {
        switch self {
        case .dailyTask:
            return UIImage(systemName: "play")
        case .weeklyTask:
            return UIImage(systemName: "pause")
        case .addTask:
            return UIImage(named: "icon_add")?.withRenderingMode(.alwaysOriginal)
        case .monthlyTask:
            return UIImage(systemName: "cloud")
        case .mypage:
            return UIImage(systemName: "person")
        }
    }
    
    var selectedIcon: UIImage? {
        switch self {
        case .dailyTask:
            return UIImage(systemName: "play.fill")
        case .weeklyTask:
            return UIImage(systemName: "pause.fill")
        case .addTask:
            return UIImage(named: "icon_add")?.withRenderingMode(.alwaysOriginal)
        case .monthlyTask:
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
