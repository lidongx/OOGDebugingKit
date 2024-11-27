//
//  ThreadSafeArray.swift
//  FIREvents
//
//  Created by DongDong on 2023/10/25.
//

import Foundation

/// 线程安全数组
public class ThreadSafeArray<Element> {

    private var internalArray: [Element] = []

    private let accessQueue = DispatchQueue(label: "com.FIREvents.threadSafeArray", attributes: .concurrent)

    public var count: Int {
        accessQueue.sync { internalArray.count }
    }

    public subscript(index: Int) -> Element {
        get {
            accessQueue.sync { internalArray[index] }
        }

        set(newValue) {
            accessQueue.async(flags: .barrier) {
                self.internalArray[index] = newValue
            }
        }
    }

    public init() {        
    }
    
    public func append(_ element: Element) {
        accessQueue.async(flags: .barrier) {
            self.internalArray.append(element)
        }
    }

    public func remove(at index: Int) {
        accessQueue.async(flags: .barrier) {
            self.internalArray.remove(at: index)
        }
    }

    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        accessQueue.async(flags: .barrier) {
            self.internalArray.removeAll(keepingCapacity: keepCapacity)
        }
    }

    public var array: [Element] {
        accessQueue.sync { internalArray }
    }
}
