//
//  AppDelegate.swift
//  TestOOGDebugingKit
//
//  Created by lidong on 2024/11/6.
//

import UIKit
import Components
import FIREvents
import OOGDebugingKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        OOGDebugingKit.setup(onlyDebug: true, otherButtonsConfig: [
            .init(buttonText: "HILKLMNOPQ", callback: { btn in
                Toast.message("Test1").show()
            }),
            
            .init(buttonText: "Test2", callback: { btn in
                Toast.message("Test2").show()
            }),
            
            .init(buttonText: "Firebase", callback: { btn in
                    Toast.message("Test2").show()
            }),
            
                .init(buttonText: "Crash", callback: { btn in
                    Toast.message("Test2").show()
                }),
            
        ])
        OOGDebugingKit.config.appID = "1241414124"
        
        OOGDebugingKit.config.mixpanelDeviceID = "1241414124124141412412414141241241414124124"
        
//        OOGDebugingKit.addEvent(eventName: "OB Started", param: [
//            "111":"value",
//            "222":"value",
//            "333":true,
//            "number":5,
//            "country":"中国开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境中国开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境",
//            "开发环境":"Debug",
//            "手机系统":"ios 18"
//        ],platform: .mixpanel)
//        
//        DebugingEvents.addEvent(name: "OB Started", param: [
//            "111":"value",
//            "222":"value",
//            "333":true,
//            "number":5,
//            "country":"中国开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境中国开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境",
//            "开发环境":"Debug",
//            "手机系统":"ios 18"
//        ],platform: .firebase)
//        
//        
//        DebugingEvents.addEvent(name: "OB Started", param: [
//            "111":"value",
//            "222":"value",
//            "333":true,
//            "number":5,
//            "country":"中国开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境中国开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境",
//            "开发环境":"Debug",
//            "手机系统":"ios 18"
//        ],platform: .mixpanel)
//        
//        
//        DebugingEvents.addEvent(name: "OB Started", param: [
//            "111":"value",
//            "222":"value",
//            "333":true,
//            "number":5,
//            "country":"中国开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境中国开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境",
//            "开发环境":"Debug",
//            "手机系统":"ios 18"
//        ],platform: .firebase)
//        
//        OOGDebugingKit
//            .addEvent(eventName: "OB Started", param: [:],platform: .mixpanel)
//        
//        OOGDebugingKit
//            .addUserProperty(name: "user property",platform: .mixpanel)
//        
//        OOGDebugingKit
//            .addUserProperty(
//                name: "property2",
//                value: "tttt",
//                platform: .mixpanel
//            )
//        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

