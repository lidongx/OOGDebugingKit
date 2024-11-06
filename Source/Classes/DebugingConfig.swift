//
//  DebugingConfig.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/24.
//

import Foundation

public class DebugingConfig {
    
    //这个是自动获取的,不需要人为设置
    public var subscriptionIsActive : Bool = false {
        didSet {
            DebugingAppInfos.setSubscription(subscriptionIsActive)
        }
    }
    
    public var appID:String = "" {
        didSet {
            DebugingAppInfos.setAppID(appID)
        }
    }
    
    public var mixpanelToken: String = "" {
        didSet {
            DebugingAppInfos.setMixpanelToken(mixpanelToken)
        }
    }
    
    public var mixpanelDeviceID: String = "" {
        didSet {
            DebugingAppInfos.setMixpanelDeviceID(mixpanelDeviceID)
        }
    }
    
    public var statsigApiKey: String = "" {
        didSet {
            DebugingAppInfos.setStagsigAPIKey(statsigApiKey)
        }
    }
    
    public var adaptyKey: String = "" {
        didSet {
            DebugingAppInfos.setAdaptyKey(adaptyKey)
        }
    }
    
    public var adaptyLevel: String = "" {
        didSet {
            DebugingAppInfos.setAdaptyLevel(adaptyLevel)
        }
    }
    
    public var supperWallKey: String = "" {
        didSet {
            DebugingAppInfos.setSupperWallKey(supperWallKey)
        }
    }
    
    public var oneSignalToken: String = "" {
        didSet {
            DebugingAppInfos.setOneSignalToken(oneSignalToken)
        }
    }
    
    public var singularKey: String = "" {
        didSet {
            DebugingAppInfos.setSingularKey(singularKey)
        }
    }
    
    public var singularSecretKey: String = "" {
        didSet {
            DebugingAppInfos.setSingularSecrectKey(singularSecretKey)
        }
    }
}
