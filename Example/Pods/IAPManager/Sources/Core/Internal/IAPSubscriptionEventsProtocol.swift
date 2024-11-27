//
//  IAPSubscriptionEventsProtocol.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/4.
//

import Foundation
import FIREvents

public protocol SubscriptionViewEventsProtocol { }

public extension SubscriptionViewEventsProtocol {
    ///发送 paywall 相关事件
    func sendPaywallTrigerEvent(
        designId: String,
        productIDs: [String],
        paywallSource: IAPManager.PaywallSource?,
        paywallType: IAPManager.PaywallType?,
        eventsType: FIREvents.IAPManager_Revenue
    ) {

        let products = productIDs.compactMap{ $0.components(separatedBy: ".").last }

        let eventModel = IAPManager.EventRevenueModel(
            paywallSource: paywallSource,
            paywallType: paywallType,
            productIDs: products,
            designId: designId)
        let params = IAPManager.getRevenueEvent(model: eventModel).revenueEventParams
        //TODO: 额外事件处理
        FIREvents.sendRevenueEvents(event: eventsType, param: params)
        switch eventsType {
            case .purchase_completed:
                FIREvents.setIAPUserProperty(name: .purchase_from, value: params[.paywall_source])
            default:
                break
        }
        if paywallSource == .onboarding {
            switch eventsType {
            case .trial_started:
                FIREvents.sendRevenueEvents(event: .ob_paywall_trialed, param: params)
            case .paywall_viewed:
                FIREvents.sendRevenueEvents(event: .ob_paywall_viewed, param: params)
            case .purchase_completed:
                FIREvents.sendRevenueEvents(event: .ob_paywall_purchased, param: params)
            case .purchase_continued:
                FIREvents.sendRevenueEvents(event: .ob_paywall_continued, param: params)
            default:
                break
            }
        }
    }

    ///发送 购买
    func sendSubscriptionEvent(productID: String, eventsType: FIREvents.IAPManager_Revenue) {
        var params = [FIREvents.IAPManager_Revenue.Parameter: Any]()
        if let productIdsSuffix = productID.components(separatedBy: ".").last {
            params[.product_id] = [productIdsSuffix]
            FIREvents.sendRevenueEvents(event: eventsType, param: params)
        }
    }
}
