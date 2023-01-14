//
//  WKExtensionDelegator.swift
//  DobbyMini WatchKit Extension
//
//  Created by yongmin lee on 1/12/23.
//

import WatchKit
import WatchConnectivity
import SwiftyBeaver

let BeaverLog = SwiftyBeaver.self

class WKExtensionDelegator: NSObject, WKExtensionDelegate {
    let localStorage = LocalStorageServiceImpl.shared
    
    func applicationDidFinishLaunching() {
        print("watchKit application DidFinishLaunching")
        // WatchConnectivity
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func applicationWillEnterForeground() {
        print("watchKit application WillEnterForeground")
    }
    
    func applicationDidBecomeActive() {
        print("watchKit application DidBecomeActive")
        
        let receiveData = WCSession.default.receivedApplicationContext
        if receiveData.isEmpty == false,
           let receiveTimeStr = receiveData[LocalKey.lastUpdateAt.rawValue] as? String,
           let receiveTime = receiveTimeStr.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss") {
            if let lastUpdateTime = self.localStorage.read(key: .lastUpdateAt)?
                .toDate(dateFormat: "yyyy-MM-dd HH:mm:ss"),
               receiveTime < lastUpdateTime {
                // watch app 토큰이 더 최신
                return
            }
            // watch app token 갱신
            if let access = receiveData[LocalKey.accessToken.rawValue] as? String {
                self.localStorage.write(key: .accessToken, value: access)
            }
            if let refresh = receiveData[LocalKey.refreshToken.rawValue] as? String {
                self.localStorage.write(key: .refreshToken, value: refresh)
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .didReLogin, object: nil)
            }
        }
    }
}

extension WKExtensionDelegator: WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
    }
    
    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String: Any]
    ) {
        if applicationContext.isEmpty == false,
           let receiveTimeStr = applicationContext[LocalKey.lastUpdateAt.rawValue] as? String,
           let receiveTime = receiveTimeStr.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss") {
            if let lastUpdateTime = self.localStorage.read(key: .lastUpdateAt)?
                .toDate(dateFormat: "yyyy-MM-dd HH:mm:ss"),
               receiveTime < lastUpdateTime {
                // watch app 토큰이 더 최신
                return
            }
            // watch app token 갱신
            if let access = applicationContext[LocalKey.accessToken.rawValue] as? String {
                self.localStorage.write(key: .accessToken, value: access)
            }
            if let refresh = applicationContext[LocalKey.refreshToken.rawValue] as? String {
                self.localStorage.write(key: .refreshToken, value: refresh)
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .didReLogin, object: nil)
            }
        }
    }
}
