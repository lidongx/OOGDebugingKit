//
//  OOGDebugingKit.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/24.
//

import Foundation
import UIKit
import Components
import IAPManager
import FIREvents
public class OOGDebugingKit {
    
    private static var installed = false
    
    private static var `default` = DebugingConfig()
    
    public static func setup(
        otherButtonsConfig:[DebugingOtherButtonConfig] = []
    ) {
        installed = true
#if DEBUG
        initLoad()
        DebugingOtherButtonConfigs.items = otherButtonsConfig
#endif
       
    }

    private static func initLoad(){
        UIWindow.swizzle
        NetworkMonitor.setup()
        
        if DebugingSettingType.fps.opened {
            DebugingFrameRate.shared.start()
        }
        
        if DebugingSettingType.memoryUse.opened {
            DebugingMemoryChecker.shared.start()
        }

        IAPManager.notificationCenter
            .addObserver(needUpdatePurchaseState: self, selector: #selector(purchaseStateChanged))
        
        updateEventsData()
    }
    
    static func updateEventsData(){
        let mixpanelEvents = FIREvents.logs(platform: .mixPanel)
        for event in mixpanelEvents {
            DebugingEvents.addEvent(
                    name: event.name,
                    param: event.param ?? [:],
                    platform: .mixpanel
            )
        }
        let firebaseEvents = FIREvents.logs(platform: .firebase)
        for event in firebaseEvents {
            DebugingEvents.addEvent(
                    name: event.name,
                    param: event.param ?? [:],
                    platform: .firebase
            )
        }
        
        FIREvents.hookEvents { name, param in
            DebugingEvents.addEvent(
                    name: name,
                    param: param ?? [:],
                    platform: .firebase
            )
        }
    }
    
    @objc func purchaseStateChanged(){
        DebugingAppInfos.setSubscription(IAPManager.shared.isActive)
    }
    
    public static var config:DebugingConfig {
        return OOGDebugingKit.default
    }
    
    private static func validInstalled(){
        if installed {
            return
        }
        assert(false, "需先在在Appdelegate的函数didFinishLaunchingWithOptions中调用OOGDebugingKit.setup()")
    }
    
    public static func addEvent(
        eventName:String,
        param:[String:Any],
        platform:DebugingEventsPlatform
    ){
        validInstalled()
        DebugingEvents
            .addEvent(name: eventName, param: param,platform: platform)
    }
    
    public static func addEvent(eventName:String,platform:DebugingEventsPlatform){
        validInstalled()
        DebugingEvents.addEvent(name: eventName, param: [:],platform: platform)
    }
    
    static func addUserProperty(name:String,value:Any,platform:DebugingEventsPlatform){
        validInstalled()
        DebugingEvents
            .addUserProperty(name: name, value: value,platform: platform)
    }
    
    static func addUserProperty(name:String,platform:DebugingEventsPlatform) {
        validInstalled()
        DebugingEvents.addUserProperty(name: name, platform: platform)
    }
    
}
