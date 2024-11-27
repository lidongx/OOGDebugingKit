//
//  EmptyPurchase.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/8.
//

import Foundation

final class EmptyPurchase: IAPManagerInterface {
    var iapSubID: String? { nil }
    
    func getProducts(placementID: String, completion: (([any IAPProduct]) -> Void)?) {
        
    }
    
    func getOfferingOrPaywall(placementID: String, completion: (((any IAPOfferOrPaywall)?) -> Void)?) {
        
    }

    
    func updateProfile(_ name: IAPProfileCategory, value: String?) {
        
    }
    
    func setAttribution(_ name: IAPAttribution, value: String?) {
    }
    
    enum EmptyPurchaseNotiType: String, IAPNotification {
        case trialStarted
        case subscriptionRenewed
        case subscriptionConverted
        case needUpdatePurchaseState
        case purchaseCompleted
    }
    
    static var instance: IAPManagerInterface {
        return EmptyPurchase()
    }
    
    var isRenew: Bool = false
    
    var isTrial: Bool = false
    
    var isActive: Bool = false
    
    func login(uid: String, completion: ((Bool) -> Void)?) { }
    
    func logout(completion: ((Bool) -> Void)?) { }
    
    static var iapNotificationType: any IAPNotification.Type {
        return EmptyPurchaseNotiType.self
    }
    
    func iapInitialize(configParams: any IAPConfiguration, completion: (((any Error)?) -> Void)?) {
        
    }
    
    func purchase(productID: String, buyHandle: IAPPurchaseBlock?) {
        
    }
    
    func purchase(product: any IAPProduct, buyHandle: IAPPurchaseBlock?) {
        
    }
    
    func restore(handle: IAPPurchaseBlock?) {
        
    }
    
}
