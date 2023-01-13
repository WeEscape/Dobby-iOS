//
//  WKExtensionDelegator.swift
//  DobbyMini WatchKit Extension
//
//  Created by yongmin lee on 1/12/23.
//

import WatchKit
import WatchConnectivity

class WKExtensionDelegator: NSObject, WKExtensionDelegate {
    let localStorage = LocalStorageServiceImpl.shared
    
    func applicationDidFinishLaunching() {
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func applicationDidBecomeActive() {
        let receiveData = WCSession.default.receivedApplicationContext
        print("debug : applicationDidBecomeActive")
        if receiveData.isEmpty == false {
            print(receiveData)
            if let access = receiveData[LocalKey.accessToken.rawValue] as? String {
                print("debug : write access -> \(access)")
                self.localStorage.write(key: .accessToken, value: access)
            }
        } else {
            print("debug : no receiveData")
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
        didReceiveApplicationContext applicationContext: [String : Any]
    ) {
        //
    }
}
