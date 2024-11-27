//
//  IAPInterface.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/4.
//

import Foundation

public typealias IAPPurchaseBlock = (_ result: IAPPurchaseResult) -> Void

/// 内购SDK必须实现的协议
public protocol IAPManagerInterface {
    
    /// 返回内购SDK的实例
    static var instance: IAPManagerInterface { get }
    
    /// 内购SDK必须要有的几个通知
    static var iapNotificationType: any IAPNotification.Type { get }
    
    ///是否自动续订
    var isRenew: Bool { get }

    ///是否处于订阅试用期
    var isTrial: Bool { get }

    ///是否处于订阅有效期
    var isActive: Bool { get }
    
    /// 用户的订阅平台ID
    var iapSubID: String? { get }
    
    /// 登录
    func login(uid: String, completion: ((Bool) -> Void)?)
    
    /// 登出
    func logout(completion: ((Bool) -> Void)?)
    
    ///初始化
    func iapInitialize(configParams: IAPConfiguration, completion: ((Error?) -> Void)?)
    /// 购买方法
    /// - Parameters:
    ///   - productID: 指定购买的产品
    ///   - buyHandle: 购买结果的回调
    func purchase(product: IAPProduct, buyHandle: IAPPurchaseBlock?)
    
    /// 恢复方法
    /// - Parameters:
    ///   - handle: 恢复结果的回调
    func restore(handle: IAPPurchaseBlock?)
    /// 获取指定placement的[offer/paywall]
    /// - Parameter placementID: 外界传递的placementID
    /// - Parameter completion: 结果回调
    func getOfferingOrPaywall(
        placementID: String,
        completion: ((IAPOfferOrPaywall?) -> Void)?
    )
    
    /// 属性归因设置
    func setAttribution(_ name: IAPAttribution, value: String?)
    
    /// 个人信息数据收集
    func updateProfile(_ name: IAPProfileCategory, value: String?)
}


