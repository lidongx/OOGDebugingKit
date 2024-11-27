//
//  Util+Synchronized.swift
//  Components
//
//  Created by lidong on 2023/1/30.
//

import Foundation

@discardableResult
public func synchronized<T>(_ lock: AnyObject, closure:() -> T) -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return closure()
}
