//
//  IAPPurchase.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/8.
//

import Foundation

public struct IAPPurchaseSDK {
    let sdk: IAPManagerInterface.Type

    public static let empty: IAPPurchaseSDK = .init(sdk: EmptyPurchase.self)
    
    public static func create(_ type: IAPManagerInterface.Type) -> Self {
        return .init(sdk: type)
    }
    
    internal var platform: IAPManagerInterface { sdk.instance }
    
    internal var isEmpty: Bool {
        return sdk is EmptyPurchase.Type
    }
}
