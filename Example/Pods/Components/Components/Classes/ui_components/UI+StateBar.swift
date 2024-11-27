//
//  UI+StateBar.swift
//  UIComponents
//
//  Created by lidong on 2022/6/10.
//

import Foundation
import UIKit

public class StateBar{
    
    //状态栏的高度
    public static var barHeight:CGFloat{
        get{
            var value: CGFloat = 0
            if let window = UIWindow.main{
                if let temp = window.windowScene?.statusBarManager?.statusBarFrame.height{
                    value = temp
                }
            }
            //默认值
            return value > 0 ? value : (StateBar.isHaveDynamicIsland ? 54: rIphoneX(44, 20))
        }
    }
    
    //横屏状态下isHaveDynamicIsland为false
    public static let isHaveDynamicIsland: Bool = {
        var isHave = false
        if #available(iOS 16.0, *) {
            isHave = UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 >= 51
        }
        return isHave
    }()
}


