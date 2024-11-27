//
//  IAPOfferOrPaywall.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/9.
//

import Foundation

fileprivate struct AdaptyRemoteConfig: Codable {
    public let paywallDesigns: [IAPManager.PaywallDesigns]?
    enum CodingKeys: String, CodingKey {
        case paywallDesigns = "paywall_designs"
    }
}

extension IAPManager {
    public struct PaywallDesigns: Codable {
        public let design: String?
        public let products: [String]?
        public let title: String?
        public let subTitle: String?
        public let button: String?
        enum CodingKeys: String, CodingKey {
            case products = "proucts"        // JSON中单词写错了。只能在这儿做兼容。。
            case design = "design"
            case title = "title"
            case subTitle = "sub-title"
            case button = "button"
        }
        
        public init?(dict: [String: Any]) {
            self.design = dict["design"] as? String
            self.products = dict["products"] as? [String]
            self.title = dict["title"] as? String
            self.subTitle = dict["sub-title"] as? String
            self.button = dict["button"] as? String
        }
    }
}

public protocol IAPOfferOrPaywall {
    var remoteConfigString: String? { get }
    
    func getProductList() async -> [IAPProduct]
    
    func logShow()
}

public extension IAPOfferOrPaywall {
    
    var remoteConfigString: String? { return nil }
    
    func logShow() { }
    
    var paywallDesigns: [IAPManager.PaywallDesigns]? {
        return remoteConfig?.paywallDesigns
    }
    
    private var remoteConfig: AdaptyRemoteConfig? {
        guard let js = remoteConfigString else {
            return nil
        }
        let configString = js.replacingOccurrences(of: "\\", with: "")
        guard let jsonData = configString.data(using: .utf8) else {
            return nil
        }
        return try? JSONDecoder().decode(AdaptyRemoteConfig.self, from: jsonData)
    }
}
