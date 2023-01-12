//
//  SessionDelegator.swift
//  Dobby
//
//  Created by yongmin lee on 1/11/23.
//

import Foundation
import WatchConnectivity

class SessionDelegator: NSObject, WCSessionDelegate {
    
    let localStorage: LocalStorageService
    
    init(localStorage: LocalStorageService) {
        self.localStorage = localStorage
    }
    
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        session.activate()
    }
#endif
    
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let accessToken = message[LocalKey.accessToken.rawValue] as? String {
            localStorage.write(key: .accessToken, value: accessToken)
        }
        if let refreshToken = message[LocalKey.refreshToken.rawValue] as? String {
            localStorage.write(key: .refreshToken, value: refreshToken)
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        if let accessToken = applicationContext[LocalKey.accessToken.rawValue] as? String {
            localStorage.write(key: .accessToken, value: accessToken)
        }
        if let refreshToken = applicationContext[LocalKey.refreshToken.rawValue] as? String {
            localStorage.write(key: .refreshToken, value: refreshToken)
        }
    }
}
