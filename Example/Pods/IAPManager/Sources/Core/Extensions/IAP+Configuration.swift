//
//  IAP+Configuration.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/5.
//

import Foundation
import UIKit
extension IAPManager {
    internal struct IAPManagerConfig: IAPConfigInit{
        
        var iapPlacements: [String] = []
        
        var iapPublicKey: String = ""
        
        var iapIdentify: String = ""
        
        var iapWebIdentify: String?
        
        var iapUserID: String?
        
        // paywall
        
        var iapPaywallPublicKey: String = ""
        
        var iapPaywallDataCollectionEnable: Bool = true
        
        var iapPaywallLocaleIdentifier: String?
        
        var iapPaywallBGColor: UIColor?
        
        var iapPaywallLoadingColor: UIColor?
        
        var iapPaywallProperty: [String: Any]?
    }
}
