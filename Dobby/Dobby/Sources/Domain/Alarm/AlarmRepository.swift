//
//  AlarmRepository.swift
//  Dobby
//
//  Created by yongmin lee on 1/2/23.
//

import Foundation

protocol AlarmRepository {
    func setAlarm(isOn: String, time: String)
    func getAlarm() -> (isOn: String?, time: String?)
}
