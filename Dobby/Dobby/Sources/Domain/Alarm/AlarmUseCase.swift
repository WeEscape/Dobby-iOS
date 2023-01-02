//
//  AlarmUseCase.swift
//  Dobby
//
//  Created by yongmin lee on 1/2/23.
//

import Foundation
import RxSwift

protocol AlarmUseCase {
    func setAlarm(isOn: Bool, time: Date)
    func getAlarm() -> (isOn: Bool, time: Date)
}

final class AlarmUseCaseImpl: AlarmUseCase {
    
    let alarmRepository: AlarmRepository
    var defaultTime: Date {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.hour, .minute], from: Date())
        component.hour = 9
        component.minute = 0
        let time = calendar.date(from: component)
        return time!
    }
    
    init(alarmRepository: AlarmRepository) {
        self.alarmRepository = alarmRepository
    }
    
    func setAlarm(isOn: Bool, time: Date) {
        self.alarmRepository.setAlarm(
            isOn: isOn ? "1" : "0",
            time: time.toStringWithFormat("HH:mm")
        )
    }
    
    func getAlarm() -> (isOn: Bool, time: Date) {
        let ret = self.alarmRepository.getAlarm()
        let retIsOn = ret.isOn ?? "0"
        let retTime = ret.time ?? ""
        
        return (
            retIsOn == "1" ? true : false,
            retTime.toDate(dateFormat: "HH:mm") ?? self.defaultTime
        )
    }
}
