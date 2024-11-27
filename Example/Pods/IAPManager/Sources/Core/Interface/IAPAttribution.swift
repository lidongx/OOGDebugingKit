//
//  IAPAttribution.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/8.
//

import Foundation

public enum IAPAttribution {
    case adjustID
    case appsFlyerID
    case fBAnonID
    case mpParticleID
    case oneSignalID
    case oneSignalUserID
    case airshipChannelID
    case cleverTapID
    case mixpanelDistinctID
    case firebaseAppInstanceID
    
    case custom(key: String)
}

public enum IAPProfileCategory {
    case amplitudeDeviceId
    case mixpanelUserId
    case oneSignalSubscriptionId
    case custom(key: String)
}
