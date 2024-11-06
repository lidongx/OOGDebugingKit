//
//  DebugingMemoryChecker.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/25.
//

import Foundation

class DebugingMemoryChecker {
    
    static let shared = DebugingMemoryChecker()
    
    private var timer: Timer?
    
    @Published
    var memoryUsage:String = DebugingAppInfos.getAppMemoryUsage()
    
    // 开始内存检查，指定间隔时间（单位：秒）
    func start(_ interval: TimeInterval = 5.0) {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            
            DispatchQueue.main.async {
                self?.memoryUsage = DebugingAppInfos.getAppMemoryUsage()
            }
        }
    }
    
    // 停止内存检查
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stop()
    }
    
}
