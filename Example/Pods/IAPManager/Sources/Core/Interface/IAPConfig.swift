//
//  IAPConfig.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/5.
//

import Foundation
import UIKit

#if canImport(SuperwallKit)
public typealias IAPConfigInit = IAPConfiguration & IAPPaywallConfiguration

public protocol IAPPaywallConfiguration {
    ///集成的paywall的 API key
    var iapPaywallPublicKey: String { set get }
    ///是否收集数据
    var iapPaywallDataCollectionEnable: Bool { set get }
    /// paywall本地化语言环境 比如`en_GB`...
    var iapPaywallLocaleIdentifier: String? { set get }
    ///点击购买时防止误触添加在Windown上的蒙层颜色
    var iapPaywallBGColor: UIColor? { set get }
    ///点击购买时处理交易过程的loading风火轮颜色
    var iapPaywallLoadingColor: UIColor? { set get }
    ///paywall初始化的时候需要的属性
    var iapPaywallProperty: [String: Any]? { set get }
}
#else
public typealias IAPConfigInit = IAPConfiguration
#endif

/// IAPManager 初始化需要的配置
public protocol IAPConfiguration {
    
    /// 项目所有的placement
    var iapPlacements: [String] { set get }
    
    /// 各个平台配置的apiKey
    var iapPublicKey: String { set get }
    
    /// 各个平台获取移动端订阅信息的配置
    /// 比如RC后台配置的Entitlement，或者 Adapty的Access level
    var iapIdentify: String { set get }
    
    /// 各个平台获取Web订阅信息的配置
    /// 比如[RC/Adapty]集成Stripe以后针对web端配置的产品列表的[Entitlement/Access level]
    var iapWebIdentify: String? { set get }
    
    /// 指定IAP的用户id
    var iapUserID: String? { set get }
}
