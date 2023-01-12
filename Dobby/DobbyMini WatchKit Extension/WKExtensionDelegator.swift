//
//  WKExtensionDelegator.swift
//  DobbyMini WatchKit Extension
//
//  Created by yongmin lee on 1/12/23.
//


import WatchKit
import WatchConnectivity

class WKExtensionDelegator: NSObject, WKExtensionDelegate {
    
    let sessionDelegator = SessionDelegator(
        localStorage: LocalStorageServiceImpl.shared
    )
    
    func applicationDidFinishLaunching() {
        print("debug : WKExtensionDelegator applicationDidFinishLaunching " )
        WCSession.default.delegate = self.sessionDelegator
        WCSession.default.activate()
    }
    
    
    func applicationDidBecomeActive() {
        print("debug : watch applicationDidBecomeActive @@ 21" )
        let receiveData = WCSession.default.receivedApplicationContext
        if receiveData.isEmpty == false {
            
        } else {
            
        }
    }
}
