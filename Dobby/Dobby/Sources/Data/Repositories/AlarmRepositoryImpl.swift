//
//  AlarmRepositoryImpl.swift
//  Dobby
//
//  Created by yongmin lee on 1/2/23.
//

import Foundation

final class AlarmRepositoryImpl: AlarmRepository {
    
    let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    func setAlarmInfo(isOn: String, time: String) {
        let text = isOn + "/" + time
        if let dir = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("alarm.txt")
            try? text.write(to: fileURL, atomically: true, encoding: .utf8)
        }
    }
    
    func getAlarmInfo() -> (isOn: String?, time: String?) {
        var text: String = "/"
        if let dir = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("alarm.txt")
            text = (try? String(contentsOf: fileURL, encoding: .utf8)) ?? "/"
        }
        let alarmInfo = text.components(separatedBy: "/")
        let isOn = alarmInfo[safe: 0]
        let time = alarmInfo[safe: 1]
        return (isOn, time)
    }
}
