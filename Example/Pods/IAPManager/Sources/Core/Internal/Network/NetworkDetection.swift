//
//  NetworkDetection.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/12.
//

import Foundation
import Alamofire

class NetworkDetection {
    static let shared = NetworkDetection()
    
    typealias Callback = (_ hasNetwork: Bool) -> Void
    typealias ListenerIdentifier = String
    
    private let netwotk = NetworkReachabilityManager()
    
    private var dict: [ListenerIdentifier: Callback] = [:]
    
    var hasNetwork: Bool {
        return netwotk?.isReachable ?? false
    }
    
    private init() {
        netwotk?.startListening { [weak self] _ in
            self?.notifyListeners()
        }
    }
    
    private func notifyListeners() {
        let b = hasNetwork
        dict.values.forEach{ $0(b) }
    }
    
    func add(listener: @escaping Callback) -> ListenerIdentifier {
        let key = UUID().uuidString
        dict[key] = listener
        return key
    }
    
    func remove(listener: ListenerIdentifier) {
        dict[listener] = nil
    }
}
