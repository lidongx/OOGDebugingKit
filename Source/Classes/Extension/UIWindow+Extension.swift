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
        
        if DebugingSettings.showWindow {
            UIWindow.panelWindow.isHidden = false
        }
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
    
    static var debugingButtonWindow: DebugingButtonWindow = {
        var res = DebugingButtonWindow(frame: CGRect(x: 0, y: 100, width: 100, height: 80))
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
    
     static var panelWindow: DebugingPanelWindow = {
        var res = DebugingPanelWindow(
            frame: CGRect(
                x: fullScreenWidth()/2 - 150,
                y: 300,
                width: 300,
                height: DebugingPanelWindow.windowHieght
            )
        )
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene{
            res.windowScene = scene
        }
        res.windowLevel = .statusBar + 300
        res.isHidden = false
        return res
    }()
    
}

