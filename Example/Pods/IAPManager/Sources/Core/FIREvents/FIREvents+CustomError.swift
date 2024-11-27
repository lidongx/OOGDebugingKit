//
//  FIREvents+CustomError.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/4.
//

import Foundation
import FIREvents

extension FIREvents {
    
    static func sendCustomEvents(event: FIREvents.IAPManager_Custom,
                                         param: [FIREvents.IAPManager_Custom.Parameter: Any]? = nil) {
        FIREvents.sendEvents(event: event, param: param)
    }
    
    enum IAPManager_Custom: String, FIREventSendable {
        public var platforms: Set<Platform> {
            return IAPManager.shared.eventsPlatforms
        }
        
        case restoreReceiptKVO = "MissingReceiptFile"

        public var category: String {
            return "Revenue"
        }

        public enum Parameter: String, FIRParameterDataType, CaseIterable {
            case subID = "subID"
            case device = "device"
            case space = "space"
            case isSubscribe = "isSubscribe"
            case error = "error"
            case code = "code"
            public static let properties: [Self] = Self.allCases

            public static let propertiesTypes: [Self: Any.Type] = [
                .subID: String.self,
                .device: String.self,
                .space: String.self,
                .isSubscribe: Bool.self,
                .error: String.self,
                .code: Int.self
            ]
        }
    }
}
