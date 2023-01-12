//
//  DobbyApp.swift
//  DobbyMini WatchKit Extension
//
//  Created by yongmin lee on 1/9/23.
//

import SwiftUI

@main
struct DobbyApp: App {
    
    @WKExtensionDelegateAdaptor private var extensionDelegate: WKExtensionDelegator
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

//        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
