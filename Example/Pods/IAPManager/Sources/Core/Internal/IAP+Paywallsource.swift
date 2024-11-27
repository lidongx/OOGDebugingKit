//
//  IAP+Paywallsource.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/4.
//

import Foundation

extension IAPManager {
    /// 弹出Superwall的页面来源
    public enum PaywallSource: Equatable {
        case onboarding
        case settings
        case lockedWorkout
        case lockedMusic
        case customWorkoutLimit
        case promo
        case onloading
        case dedicate
        case lockedProgram
        case banner
        
        ///外部传入
        case other(name: String)
        
        public var sourceName: String {
            switch self {
                case .onboarding: return "onboarding"
                case .settings: return "settings"
                case .lockedWorkout: return "locked workout"
                case .lockedMusic: return "locked music"
                case .customWorkoutLimit: return "custom workout limit"
                case .promo: return "promo"
                case .onloading: return "onloading"
                case .dedicate: return "dedicate"
                case .lockedProgram: return "locked program"
                case .banner: return "banner"
                case .other(let name): return name
            }
        }
    }
}
