//
//  AlarmRepository.swift
//  Dobby
//
//  Created by yongmin lee on 1/2/23.
//

import Foundation

protocol AlarmRepository {
    func setAlarmInfo(isOn: String, time: String)
    func getAlarmInfo() -> (isOn: String?, time: String?)
}
