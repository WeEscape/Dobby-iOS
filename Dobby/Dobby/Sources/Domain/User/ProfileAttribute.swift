//
//  ProfileAttribute.swift
//  Dobby
//
//  Created by yongmin lee on 11/4/22.
//

import Foundation

enum ProfileAttribute: Int, CaseIterable {
    case color
    case photo
}

extension ProfileAttribute: CustomStringConvertible {
    var description: String {
        switch self {
        case .color:
            return "색상"
        case .photo:
            return "사진"
        }
    }
}
