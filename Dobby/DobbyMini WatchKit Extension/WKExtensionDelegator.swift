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
        // WatchConnectivity
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func applicationWillEnterForeground() {
        print("applicationWillEnterForeground")
    }
    
    func applicationDidBecomeActive() {
        print("applicationDidBecomeActive ##")
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

    }
}
