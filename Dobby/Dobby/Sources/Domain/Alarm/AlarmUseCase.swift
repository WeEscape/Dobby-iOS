//
//  AlarmUseCase.swift
//  Dobby
//
//  Created by yongmin lee on 1/2/23.
//

import Foundation
import RxSwift

protocol AlarmUseCase {
    func setAlarmInfo(isOn: Bool, time: Date)
    func getAlarmInfo() -> (isOn: Bool, time: Date)
    func registAlarm(at: Date, isTodayAlarm: Bool)
    func removeAllAlarm()
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
    
    func setAlarmInfo(isOn: Bool, time: Date) {
        self.alarmRepository.setAlarmInfo(
            isOn: isOn ? "1" : "0",
            time: time.toStringWithFormat("HH:mm")
        )
    }
    
    func getAlarmInfo() -> (isOn: Bool, time: Date) {
        let ret = self.alarmRepository.getAlarmInfo()
        let retIsOn = ret.isOn ?? "0"
        let retTime = ret.time ?? ""
        
        return (
            retIsOn == "1" ? true : false,
            retTime.toDate(dateFormat: "HH:mm") ?? self.defaultTime
        )
    }
    
    func registAlarm(at alarmTime: Date, isTodayAlarm: Bool) {
        let nowStr = Date().toStringWithFormat("HH:mm")
        let nowHour = Double(nowStr.split(separator: ":").first!)!
        let nowMin = Double(nowStr.split(separator: ":").last!)!
        let now = (nowHour * 60) + nowMin
        let targetStr = alarmTime.toStringWithFormat("HH:mm")
        let targetHour = Double(targetStr.split(separator: ":").first!)!
        let targetMin = Double(targetStr.split(separator: ":").last!)!
        let target = (targetHour * 60) + targetMin
        
        var notificationInterval: Double = 0
        if target > now {
            notificationInterval = (target - now)
        } else if target == now, isTodayAlarm == false {
            notificationInterval = 24 * 60
        } else if target < now, isTodayAlarm == false {
            notificationInterval = (target - now) + (24 * 60)
        } else {
            return
        }
        notificationInterval *= 60 // 분단위를 초단위로 바꾸기
        
        // 기존 알람 초기화
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // 알람메세지
        let content = UNMutableNotificationContent()
        content.title = "Dobby"
        content.body = "오늘 해야할 집안일이 있어요!"
        content.badge = 1
        content.sound = .default
        
        // 알람 등록
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: notificationInterval,
            repeats: false
        )
        let req = UNNotificationRequest(
            identifier: alarmTime.toStringWithFormat(),
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(req)
    }
    
    func removeAllAlarm() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
