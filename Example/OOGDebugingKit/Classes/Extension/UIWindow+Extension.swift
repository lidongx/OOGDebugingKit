//
//  UIWindow+Extension.swift
//  TestSPM
//
//  Created by lidong on 2024/4/17.
//

import Foundation
import UIKit
import Components

extension UIWindow {
    public static let swizzle: Void = {
        let originalSelector = #selector(UIWindow.makeKeyAndVisible)
        let swizzledSelector = #selector(UIWindow.customMakeKeyAndVisible)
        
        guard let originalMethod = class_getInstanceMethod(UIWindow.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(UIWindow.self, swizzledSelector) else {
                return
        }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    @objc private func customMakeKeyAndVisible() {
        print("customMakeKeyAndVisible was called!")
        // 调用原始的 makeKeyAndVisible 方法
        self.customMakeKeyAndVisible()
        UIWindow.main = self
        UIWindow.debugingButtonWindow.isHidden = false
    }
    
    private static var debugingWindow: DebugingWindow = {
        var res = DebugingWindow(frame: UIWindow.main!.bounds)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene{
            res.windowScene = scene
        }
        res.onCloseAction = {
            UIWindow.debugingButtonWindow.isHidden = false
        }
        res.windowLevel = .statusBar+200
        res.isHidden = true
        return res
    }()
    
    private static var debugingButtonWindow: DebugingButtonWindow = {
        var res = DebugingButtonWindow(frame: CGRect(x: 0, y: 100, width: 60, height: 60))
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene{
            res.windowScene = scene
        }
        res.onActionAction = { _ in
            UIWindow.debugingButtonWindow.isHidden = true
            UIWindow.debugingWindow.showing = true
        }
        
        res.windowLevel = .statusBar + 100
        res.isHidden = false
        return res
    }()
}

