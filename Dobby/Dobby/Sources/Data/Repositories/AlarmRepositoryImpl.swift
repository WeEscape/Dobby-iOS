//
//  AlarmRepositoryImpl.swift
//  Dobby
//
//  Created by yongmin lee on 1/2/23.
//

import Foundation

final class AlarmRepositoryImpl: AlarmRepository {
    
    let localStorage: LocalStorageService
    
    init(localStorage: LocalStorageService) {
        self.localStorage = localStorage
    }
    
    func setAlarmInfo(isOn: String, time: String) {
        self.localStorage.write(key: .alarmOnOff, value: isOn)
        self.localStorage.write(key: .alarmTime, value: time)
    }
    
    func getAlarmInfo() -> (isOn: String?, time: String?) {        
        let isOn = self.localStorage.read(key: .alarmOnOff)
        let time = self.localStorage.read(key: .alarmTime)
        return (isOn, time)
    }
}
