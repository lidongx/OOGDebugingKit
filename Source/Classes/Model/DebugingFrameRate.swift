//
//  DebugingFrameRate.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/25.
//

import Foundation
import UIKit

class DebugingFrameRate {
    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    
    static let shared = DebugingFrameRate()
    
    @Published
    var fpsString:String = "未启用"
    
    init() {
        // 使用 CADisplayLink 监测帧率
     
    }
    
    func start(){
        
        stop()
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateFrameRate))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stop(){
        displayLink?.invalidate()
        displayLink = nil
        
        fpsString = "未启用"
    }
    
    @objc private func updateFrameRate(displayLink: CADisplayLink) {
        // 计算帧率
        if lastTimestamp == 0 {
            lastTimestamp = displayLink.timestamp
            return
        }
        
        let delta = displayLink.timestamp - lastTimestamp
        let fps = 1.0 / delta
        lastTimestamp = displayLink.timestamp
        
        // 更新帧率显示
        fpsString = String(format: "%.0f FPS", fps)
    }
    
    deinit {
        stop()
    }
}

