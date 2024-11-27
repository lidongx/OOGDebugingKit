//
//  FIREvents+UserProperty.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/4.
//

import Foundation
import FIREvents

extension FIREvents {
    
    static func setIAPUserProperty(name: FIREvents.IAPManager_CommonProperty, value: Any?) {
        FIREvents.setUserProperty(name: name, value: value)
    }
    
    public enum IAPManager_CommonProperty: String, FIRUserPropertySendable {
        
        public static var propertiesTypes: [FIREvents.IAPManager_CommonProperty : Any.Type] = [
            .trial_from: String.self,
            .purchase_from: String.self
        ]
        
        public var platforms: Set<Platform> {
            return IAPManager.shared.eventsPlatforms
        }
        
        case trial_from
        case purchase_from
    }
}
