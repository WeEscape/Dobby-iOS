//
//  SceneDelegate.swift
//  Dobby
//
//  Created by yongmin lee on 9/30/22.
//

import UIKit
import KakaoSDKAuth
import WatchConnectivity

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let localStorage = LocalStorageServiceImpl.shared
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        // root view controller
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.rootCoordinator?.startSplash(window: window)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let receiveData = WCSession.default.receivedApplicationContext
        if receiveData.isEmpty == false,
           let receiveTimeStr = receiveData[LocalKey.lastUpdateAt.rawValue] as? String,
           let receiveTime = receiveTimeStr.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss"),
           let lastUpdateTime = self.localStorage.read(key: .lastUpdateAt)?
            .toDate(dateFormat: "yyyy-MM-dd HH:mm:ss") {
            
            if receiveTime > lastUpdateTime  {
                // watch app 토큰이 더 최신인경우 -> ios 토큰 갱신
                if let access = receiveData[LocalKey.accessToken.rawValue] as? String {
                    self.localStorage.write(key: .accessToken, value: access)
                }
                if let refresh = receiveData[LocalKey.refreshToken.rawValue] as? String {
                    self.localStorage.write(key: .refreshToken, value: refresh)
                }
            } else {
                // ios 토큰이 더 최신인경우 -> watch 토큰 갱신
                guard let access = self.localStorage.read(key: .accessToken),
                      let refresh = self.localStorage.read(key: .refreshToken)
                else {return}
                let context: [String: String] = [
                    LocalKey.accessToken.rawValue: access,
                    LocalKey.refreshToken.rawValue: refresh,
                    LocalKey.lastUpdateAt.rawValue: Date().toStringWithFormat("yyyy-MM-dd HH:mm:ss")
                ]
                try? WCSession.default.updateApplicationContext(context)
            }
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        LocalStorageServiceImpl.shared.saveContext()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
