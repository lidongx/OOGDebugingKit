//
//  Platform.swift
//  FIREvents
//
//  Created by DongDong on 2023/8/14.
//

import Foundation

public enum Platform: String {
    case firebase
    case mixPanel
    case appsFlyer
    case amplitude
    case singular
    case statsig

    public var adapter: String {
        switch self {
        case .firebase:
            return "FirebaseAdapter"
        case .mixPanel:
            return "MixPanelAdapter"
        case .appsFlyer:
            return "AppsFlyerAdapter"
        case .amplitude:
            return "AmplitudeAdapter"
        case .singular:
            return "SingularAdapter"
        case .statsig:
            return "StatsigAdapter"
        }
    }
    
    var adapterClass: Adapter.Type? {
        
#if SWIFT_PACKAGE
        let name = rawValue.prefix(1).uppercased() + rawValue.dropFirst()
        let type = "FIREvents\(name)Adapter.\(adapter)"
        guard let cls = NSClassFromString(type) as? Adapter.Type else {
            if self == .mixPanel {
                let s_type = "FIREvents\(name)SwiftAdapter.\(adapter)"
                return NSClassFromString(s_type) as? Adapter.Type
            } else {
                return nil
            }
        }
        return cls
#else
        return NSClassFromString("FIREvents.\(adapter)") as? Adapter.Type
#endif
        
    }
}
