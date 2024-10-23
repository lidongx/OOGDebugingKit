//
//  AppDelegate+Extension.swift
//  TestSPM
//
//  Created by lidong on 2024/4/17.
//

import Foundation
import UIKit
extension AppDelegate{
    public static func setupDebugingKit() {
#if DEBUG
        UIWindow.swizzle
#endif
    }
}
