//
//  DebugingCrashs.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/24.
//

import Foundation

class DebugingCrashs {
    static let items:[DebugingCrashType] = [
        .indexOutOfRange,
        .forcedUnwrapping,
        .nilDereferencing,
        .divisionByZero,
        .raceCondition,
        .stackOverflow,
        .outOfMemory,
        .keyValueObserving
    ]
}


enum DebugingCrashType {
    case indexOutOfRange
    case forcedUnwrapping
    case nilDereferencing
    case divisionByZero
    case raceCondition
    case stackOverflow
    case outOfMemory
    case keyValueObserving
    
    var displayName: String {
        switch self {
        case .indexOutOfRange:
            "数组越界崩溃"
        case .forcedUnwrapping:
            "强解包崩溃"
        case .nilDereferencing:
            "空指针崩溃"
        case .divisionByZero:
            "除以0崩溃"
        case .raceCondition:
            "多线程崩溃(偶现)"
        case .stackOverflow:
            "递归循环崩溃"
        case .outOfMemory:
            "内存不足崩溃"
        case .keyValueObserving:
            "KVO崩溃"
        }
    }
}
