//
//  AppDelegate.swift
//  Dobby
//
//  Created by yongmin lee on 9/30/22.
//

import UIKit
import SwiftyBeaver
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import FirebaseMessaging

let BeaverLog = SwiftyBeaver.self

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var rootCoordinator: RootCoordinator?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // root coordinator
        rootCoordinator = RootCoordinator()
        
        // SwiftyBeaver log to Xcode Console
        let console = ConsoleDestination()
        console.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M $X"
        BeaverLog.addDestination(console)
        
        // kakao init
        KakaoSDK.initSDK(appKey: KakaoAppKey.nativeAppKey)
        
        // remote nofitication
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
        
        // Firebase
        FirebaseApp.configure()
        
        // FCM
        Messaging.messaging().delegate = self
        
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // APN에 앱이 성공적으로 등록되었음을 딜리게이트로 전달
    func application(
        application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // APN 토큰과 등록 토큰을 매핑
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // 앱이 foreground  상태일 때 Push 받으면
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions
        ) -> Void) {
        // alert를 띄우기
        completionHandler([.banner, .list, .sound])
    }
}

extension AppDelegate: MessagingDelegate {
    
    // fcmToken이 업데이트 될때마다 호출됨
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        BeaverLog.debug("debug : fcmToken -> \(fcmToken ?? "no fcm toekn")")
        // 유저 fcmToken 등록
    }
}
