//
//  Extension+UIWindow.swift
//  SevMinWorkout
//
//  Created by mac on 2021/12/7.
//

import Foundation
import UIKit

public extension UIWindow{
    
    private static var _main:UIWindow? = nil
    ///Main Window
    static var main:UIWindow?{
        get{
            if _main != nil{
                return _main
            }
            //经过测试 所有的window最终会在UIApplication.shared.windows中
            //UIWindowScene中的window还是AppleDeleagte中的window
            for window in UIApplication.shared.windows{
                if window.isHidden == false{
                    return window
                }
            }
            return nil
        }set{
            _main = newValue
        }
    }
}



public extension UIWindow {
    //最上层的ViewControler
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}
