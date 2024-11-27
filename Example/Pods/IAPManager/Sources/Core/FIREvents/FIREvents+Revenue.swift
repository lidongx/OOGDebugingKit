//
//  FIREvents+Revenue.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/4.
//

import Foundation
import FIREvents

extension FIREvents {
    
    /// 发送Revenue事件
    public static func sendRevenueEvents(event: FIREvents.IAPManager_Revenue,
                                         param: [FIREvents.IAPManager_Revenue.Parameter: Any]? = nil) {
        var dict = param
        switch event {
            case .ob_paywall_viewed, .ob_paywall_trialed, .ob_paywall_continued, .ob_paywall_purchased:
                dict?.removeValue(forKey: .paywall_source)
                dict?.removeValue(forKey: .paywall_type)
            default:
                break
        }
        FIREvents.sendEvents(event: event, param: dict)
    }
    
    public enum IAPManager_Revenue: String, CaseIterable, FIREventSendable {
        
        public static func eventNameMapping(platform: Platform) -> [FIREvents.IAPManager_Revenue : String]? {
            if [Platform.mixPanel, Platform.statsig].contains(platform) {
                return [
                    .paywall_viewed: "Paywall Viewed",
                    .trial_started: "Paywall Trialed",
                    .purchase_completed: "Paywall Purchased",
                    .purchase_continued: "Paywall Continued",
                    .subscription_converted: "Subscription Converted",
                    .subscription_renewed: "Subscription Renewed",
                ]
            }
            
            return nil
        }
        
        public var platforms: Set<Platform> {
            switch self {
                case .paywall_closed:
                    // paywall_closed只给Firebase发
                    return IAPManager.shared.eventsPlatforms.intersection([.firebase])
                case .ob_paywall_trialed, .ob_paywall_viewed, .ob_paywall_continued, .ob_paywall_purchased:
                    // ob开头的只给 MixPanel 和 Statsig 发
                    return IAPManager.shared.eventsPlatforms.intersection([.mixPanel, .statsig])
                default:
                    return IAPManager.shared.eventsPlatforms
            }
        }
        
        case banner_trial = "banner_trial"
        
        /// A user has activated a free trial subscription
        case trial_started = "trial_started"
        /// When a user left the paywall without further payment actions
        case paywall_closed = "paywall_closed"
        /// When a user see the paywalls
        case paywall_viewed = "paywall_viewed"
        /// When a free-trial subscription is converted to a paid subscription
        case subscription_converted = "subscription_converted"
        /// When user renewed purchase
        case subscription_renewed = "subscription_renewed"
        /// When user purchase completed
        case purchase_completed = "purchase_completed"
        /// When user start purchase
        case purchase_continued = "purchase_continued"
        
        case ob_paywall_viewed = "OB Paywall Viewed"
        
        case ob_paywall_trialed = "OB Paywall Trialed"
        
        case ob_paywall_continued = "OB Paywall Continued"
        
        case ob_paywall_purchased = "OB Paywall Purchased"
        
        public var category: String {
            return "Revenue"
        }
        
        public enum Parameter: String, FIRParameterDataType, CaseIterable {
            case paywall_source = "paywall_source"
            case paywall_type = "paywall_type"
            case product_id = "product_id"
            case design_id = "design_id"
            
            case activated_time = "activated_time"
            case expired_time   = "expired_time"
            case transaction_id = "transaction_id"
            case sub_id         = "sub_id"
            
            public static let properties: [Self] = Self.allCases
            
            public static let propertiesTypes: [Self: Any.Type] = [
                .paywall_source: String.self,
                .design_id: String.self,
                .paywall_type: String.self,
                .product_id: [String].self,
                .activated_time: String.self,
                .expired_time: String.self,
                .transaction_id: String.self,
                .sub_id: String.self
            ]
        }
    }
}
