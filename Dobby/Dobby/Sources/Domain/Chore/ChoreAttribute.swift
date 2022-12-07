//
//  ChoreAttribute.swift
//  Dobby
//
//  Created by yongmin lee on 10/24/22.
//

import UIKit

enum ChoreAttribute: Int, CaseIterable {
    case repeatCycle
    case startDate
    case endDate
    case owner
    case category
    case memo
}

extension ChoreAttribute: CustomStringConvertible {
    var description: String {
        switch self {
        case .startDate:
            return "시작일"
        case .endDate:
            return "종료일"
        case .repeatCycle:
            return "반복"
        case .owner:
            return "담당자"
        case .category:
            return "카테고리"
        case .memo:
            return "메모"
        }
    }
}

extension ChoreAttribute {
    var icon: UIImage? {
        switch self {
        case .startDate:
            return UIImage(named: "weekly_chore_active")?.withRenderingMode(.alwaysOriginal)
        case .endDate:
            return UIImage(named: "weekly_chore_active")?.withRenderingMode(.alwaysOriginal)
        case .repeatCycle:
            return UIImage(named: "icon_recycle")?.withRenderingMode(.alwaysOriginal)
        case .owner:
            return UIImage(named: "icon_profile")?.withRenderingMode(.alwaysOriginal)
        case .category:
            return UIImage(named: "icon_hamburger")?.withRenderingMode(.alwaysOriginal)
        case .memo:
            return UIImage(named: "icon_memo")?.withRenderingMode(.alwaysOriginal)
        }
    }
}
