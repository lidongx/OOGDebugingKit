//
//  IAPInternalError.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/8.
//

import Foundation

public class IAPInternalError: NSError {
    
    private static let domain = "IAPManager.InternalError"
    
    init(_ errcode: IAPInternalError.ErrorCode) {
        super.init(
            domain: Self.domain,
            code: errcode.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: errcode.errerMessage
            ]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum ErrorCode: Int {
        
        fileprivate var errerMessage: String {
            switch self {
                case .productNotAvailable:
                    return "The product is not available for purchase."
                case .configurationError:
                    return "There is an issue with your configuration. Check the underlying error for more details."
                case .unknownError:
                    return "unknownError"
            }
        }
        
        case productNotAvailable = 5
        
        case configurationError = 23
        
        case unknownError = 9999
    }
}
public extension IAPInternalError {
    
    var result: PurchaseResult {
        return .init(error: self)
    }
    
    /// IAPManager框架内的使用
    public struct PurchaseResult: IAPPurchaseResult {
     
        public var isBuySucess: Bool = false
        
        public var isActive: Bool = false
        
        public var error: IAPPurchaseError?
        
        public var userCancel: Bool = false
        
        public var firstDate: Date? = nil
        
        public var transactionIdentifier: String? = nil
        
        public var iapTransaction: IAPTranscation? = nil
    }
}
