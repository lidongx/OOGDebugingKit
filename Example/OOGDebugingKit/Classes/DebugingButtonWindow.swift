//
//  DebugingButtonWindow.swift
//  TestSPM
//
//  Created by lidong on 2024/4/17.
//

import Foundation
import UIKit
import SnapKit
import Components

fileprivate struct PadddingOffset {
    var top:CGFloat
    var bottom:CGFloat
    var left:CGFloat
    var right:CGFloat
}
class DebugingButtonWindow: UIWindow {

    private let offset = PadddingOffset(
        top: SafeArea.top+30,
        bottom: SafeArea.bottom+30,
        left: 30,
        right: 30
    )
    private var beginPoint: CGPoint = .zero
    private var prevPoint: CGPoint = .zero
    
    var onActionAction:((DebugingButtonWindow)->Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        addSubview(icon)
        icon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        adjustPosition()
    }
    
    lazy var icon: UIImageView = {
        let res = UIImageView(frame: CGRect(x: 0, y: 100, width: 60, height: 60))
        res.image = UIImage(named: "kit.png")
        return res
    }()
    
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
        //移动距离小判定为点击
        if distance < 5 {
            onActionAction?(self)
        }else{
            adjustPosition()
        }
    }
    /// 修正位置 动画吸附在屏幕两侧
    func adjustPosition() {
        let screenWidth = fullScreenWidth()
        let screenHeight = fullScreenHeight()
        let rect = CGRect(
            x: offset.left,
            y: offset.top,
            width: screenWidth-offset.left-offset.right,
            height: screenHeight-offset.top-offset.bottom
        )
        if !rect.contains(self.center) {
            let targetPoint = movePointToRectEdge(self.center, within: rect)
            UIView.animate(withDuration: 0.25) {
                self.center = targetPoint
            }
        }
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

