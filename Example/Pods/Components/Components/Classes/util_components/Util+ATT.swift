//
//  Util+Tracking.swift
//  Components
//
//  Created by lidong on 2022/9/20.
//

import Foundation
import AppTrackingTransparency

public typealias ATT = Tracking

public class Tracking{
    public static func requestTracking(_ callback:(()->Void)?){
        if #available(iOS 14, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                     callback?()
                })
            })
        }else{
            callback?()
        }
    }

    @available(iOS 14, *)
    public static func requestTracking(_ callback:((ATTrackingManager.AuthorizationStatus)->Void)?){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                 callback?(status)
            })
        })
    }
    
    @available(iOS 14, *)
    public static func requestTrackingAsync() async -> ATTrackingManager.AuthorizationStatus{
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    continuation.resume(returning: status)
                })
            })
        }
    }
    
    
    @available(iOS 14, *)
    public static var authorizationStatus: ATTrackingManager.AuthorizationStatus{
        return ATTrackingManager.trackingAuthorizationStatus
    }
    
}
