//
//  IAP+Util.swift
//  IAPManager
//
//  Created by chai chai on 2024/7/5.
//

import Foundation
import UIKit

extension IAPManager {
    
    internal static func topViewController(controller: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
