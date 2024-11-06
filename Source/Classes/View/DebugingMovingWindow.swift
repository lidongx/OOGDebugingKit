//
//  DebugingMovingWindow.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/28.
//

import Foundation
import UIKit

struct PadddingOffset {
    var top:CGFloat
    var bottom:CGFloat
    var left:CGFloat
    var right:CGFloat
}

class DebugingMovingWindow : UIWindow {
    
    private var beginPoint: CGPoint = .zero
    private var prevPoint: CGPoint = .zero
    
    /// 点击开始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: UIWindow.main!)
        beginPoint = currentPoint
        prevPoint = currentPoint
    }
    /// 拖动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else {return}
        let curPoint = touch.location(in: UIWindow.main!)
        let offsetPoint = CGPoint(
            x: curPoint.x-prevPoint.x,
            y: curPoint.y-prevPoint.y
        )
        prevPoint = curPoint
        self.center = CGPoint(
            x: self.center.x+offsetPoint.x, y: self.center.y+offsetPoint.y
        )
    }
    /// 点击结束
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else {return}
        let curPoint = touch.location(in: UIWindow.main!)
        // 计算两个 CGPoint 之间的差值
        let deltaX = beginPoint.x - curPoint.x
        let deltaY = beginPoint.y - curPoint.y
        // 使用 Pythagoras 定理计算距离
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        
        handleTouchesEnd(distance: distance)
        
//        //移动距离小判定为点击
//        if distance < 5 {
//            onActionAction?(self)
//        }else{
//            adjustPosition()
//        }
    }
    
    func handleTouchesEnd(distance:CGFloat) {
    }
    
    func movePointToRectEdge(_ point: CGPoint, within rect: CGRect) -> CGPoint {
        var newPoint = point
        if newPoint.x < rect.minX {
            newPoint.x = rect.minX
        } else if newPoint.x > rect.maxX {
            newPoint.x = rect.maxX
        }
        if newPoint.y < rect.minY {
            newPoint.y = rect.minY
        } else if newPoint.y > rect.maxY {
            newPoint.y = rect.maxY
        }
        return newPoint
    }
}
