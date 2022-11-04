//
//  ProfileColorSection.swift
//  Dobby
//
//  Created by yongmin lee on 11/4/22.
//

import Foundation
import RxDataSources

struct ProfileColorSection {
    var colorList: [ProfileColor]
}

extension ProfileColorSection: SectionModelType {
    
    var items: [ProfileColor] {
        return self.colorList
    }
    
    init(original: ProfileColorSection, items: [ProfileColor]) {
        self = original
        self.colorList = items
    }
}
