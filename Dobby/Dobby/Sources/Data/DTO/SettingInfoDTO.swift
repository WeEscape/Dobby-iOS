//
//  SettingInfoDTO.swift
//  Dobby
//
//  Created by yongmin lee on 1/9/23.
//

import Foundation

struct SettingInfoDTO {
    var accessToken: String
    var refreshToken: String
    var alarmOnOff: String
    var alarmTime: String
    var userInfo: Data?
    
    init(
        accessToken: String?,
        refreshToken: String?,
        alarmOnOff: String?,
        alarmTime: String?,
        userInfo: Data?
    ) {
        self.accessToken = accessToken ?? ""
        self.refreshToken = refreshToken ?? ""
        self.alarmOnOff = alarmOnOff ?? "0"
        self.alarmTime = alarmTime ?? ""
        self.userInfo = userInfo
    }
}
