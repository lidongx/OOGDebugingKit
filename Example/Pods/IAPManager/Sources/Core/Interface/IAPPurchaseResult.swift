//
//  IAPPurchaseResult.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/4.
//

import Foundation
import StoreKit

public protocol IAPTranscation {
    var sk1Transaction: SKPaymentTransaction? { get }
}

public typealias IAPPurchaseError = NSError

public protocol IAPPurchaseResult {
    /// 购买操作是否执行成功
    var isBuySucess: Bool { get }
    /// 是否处于订阅有效期
    var isActive: Bool { get }
    /// 购买过程中出现的错误
    var error: IAPPurchaseError? { get }
    /// 是否是用户手动取消购买操作
    var userCancel: Bool { get }
    /// 用户第一次使用RevenueCat的日期
    var firstDate: Date? { get }
    ///购买成功的交易id
    var transactionIdentifier: String? { get }
    ///购买成功的交易
    var iapTransaction: IAPTranscation? { get }
}
