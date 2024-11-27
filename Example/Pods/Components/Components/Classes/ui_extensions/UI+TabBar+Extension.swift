//
//  UI+TabBar+Extension.swift
//  UIComponents
//
//  Created by lidong on 2022/6/10.
//

import Foundation
import UIKit

public extension UITabBar{
    
    //Tab bar height
    static var barHeight:CGFloat{
        get{
            let height = UITabBarController().tabBar.height
            return  height > 0 ? height : 49
        }
    }
}
