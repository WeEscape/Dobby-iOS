//
//  AppDelegate.swift
//  Dobby
//
//  Created by yongmin lee on 9/30/22.
//

import UIKit
import SwiftyBeaver

let BeaverLog = SwiftyBeaver.self

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // SwiftyBeaver log to Xcode Console
        let console = ConsoleDestination()
        console.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M $X"
        BeaverLog.addDestination(console)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        
    }
}