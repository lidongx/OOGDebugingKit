//
//  ThreadSafeDictionary.swift
//  FIREvents
//
//  Created by DongDong on 2023/10/25.
//

import Foundation

/// 线程安全字典
class ThreadSafeDictionary<Key: Hashable, Value> {

    private(set) var dictionary: [Key: Value] = [:]

    private let accessQueue = DispatchQueue(label: "com.FIREvents.threadSafeDictionary", attributes: .concurrent)

    subscript(key: Key) -> Value? {
        get {
            accessQueue.sync { dictionary[key] }
        }

        set(newValue) {
            accessQueue.async(flags: .barrier) {
                self.dictionary[key] = newValue
            }
        }
    }

    var keys: Dictionary<Key, Value>.Keys {
        accessQueue.sync { dictionary.keys }
    }
}

extension ThreadSafeDictionary: Sequence {

    func makeIterator() -> Dictionary<Key, Value>.Iterator {
        accessQueue.sync { dictionary.makeIterator() }
    }
}
