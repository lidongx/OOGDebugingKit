//
//  DebugingSettings.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/25.
//

import Foundation
class DebugingSettings {
    static var items:[DebugingSettingType] =  [
        .fps,
        .memoryUse,
        .events
    ]
    
    static var showWindow:Bool {
        return DebugingSettingType.fps.opened || DebugingSettingType.memoryUse.opened || DebugingSettingType.events.opened
    }
}

enum DebugingSettingType {
    case fps
    case memoryUse
    case events
    
    var display:String {
        switch self {
        case .fps:
            "FPS"
        case .memoryUse:
            "内存使用"
        case .events:
            "Events"
        }
    }
    
    var userKey:String  {
        switch self {
        case .fps:
             "oogdebugingkit_setting_fps"
        case .memoryUse:
            "oogdebugingkit_setting_memoryuse"
        case .events:
            "oogdebugingkit_setting_events"
        }
    }
    
    var opened:Bool {
        get {
            switch self {
            case .fps:
                UserDefaults.standard
                    .bool(forKey: DebugingSettingType.fps.userKey)
            case .memoryUse:
                UserDefaults.standard
                    .bool(forKey: DebugingSettingType.memoryUse.userKey)
            case .events:
                UserDefaults.standard
                    .bool(forKey: DebugingSettingType.events.userKey)
            }
        }
        set {
            switch self {
            case .fps:
                UserDefaults.standard
                    .set(newValue, forKey: DebugingSettingType.fps.userKey)
                if newValue {
                    DebugingFrameRate.shared.start()
                }else {
                    DebugingFrameRate.shared.stop()
                }
            case .memoryUse:
                UserDefaults.standard
                    .set(newValue, forKey: DebugingSettingType.memoryUse.userKey)
            case .events:
                UserDefaults.standard
                    .set(newValue, forKey: DebugingSettingType.events.userKey)
            }
        }
    }
}
