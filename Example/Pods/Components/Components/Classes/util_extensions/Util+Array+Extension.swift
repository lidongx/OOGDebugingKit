//
//  Array+Extension.swift
//  Helper4Swift
//
//  Created by Abdullah Alhaider on 6/18/18.
//

import Foundation
import CoreMedia

public extension Array {
    /// 获取随机的一个元素
    var randomItem: Element? {
        if self.isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
    
    /// 随机数组返回
    var shuffled: [Element] {
        var arr = self
        for _ in 0..<10 {
            arr.sort { (_, _) in arc4random() < arc4random() }
        }
        return arr
    }
    
    /// 数组随机排序
    mutating func shuffle() {
        // https://gist.github.com/ijoshsmith/5e3c7d8c2099a3fe8dc3
        for _ in 0..<10 {
            sort { (_, _) in arc4random() < arc4random() }
        }
    }
    
    /// Element at the given index if it exists.
    ///
    /// - Parameter index: index of element.
    /// - Returns: optional element (if exists).
    func item(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
    
    @discardableResult
    mutating func append(_ newArray: Array) -> CountableRange<Int> {
        let range = count..<(count + newArray.count)
        self += newArray
        return range
    }
    
    @discardableResult
    mutating func insert(_ newArray: Array, at index: Int) -> CountableRange<Int> {
        let mIndex = Swift.max(0, index)
        let start = Swift.min(count, mIndex)
        let end = start + newArray.count
        
        let left = self[0..<start]
        let right = self[start..<count]
        self = left + newArray + right
        return start..<end
    }
    
    mutating func remove<T: AnyObject> (_ element: T) {
        let anotherSelf = self
        removeAll(keepingCapacity: true)
        anotherSelf.each { (_: Int, current: Element) in
            if (current as? T) !== element {
                self.append(current)
            }
        }
    }
    
    func each(_ exe: (Int, Element) -> Void) {
        for (index, item) in enumerated() {
            exe(index, item)
        }
    }
    
}

public extension Array where Element: Equatable {
    
    /// 移出重复的
    var unique: [Element] {
        return self.reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }
    
    /// 数组是否包含数组
    ///
    /// - Parameter elements: array of elements to check.
    /// - Returns: true if array contains all given items.
    func contains(_ elements: [Element]) -> Bool {
        guard !elements.isEmpty else {
            return false
        }
        var found = true
        for element in elements {
            if !contains(element) {
                found = false
            }
        }
        return found
    }
    
    /// 返回数组所有的index
    ///
    /// - Parameter item: item to check.
    /// - Returns: an array with all indexes of the given item.
    func indexes(of item: Element) -> [Int] {
        var indexes: [Int] = []
        for index in 0..<self.count where self[index] == item {
            indexes.append(index)
        }
        return indexes
    }
    
    /// Remove all instances of an item from array.
    ///
    /// - Parameter item: item to remove.
    mutating func removeAll(_ item: Element) {
        self = self.filter { $0 != item }
    }
    
    ///分组
    /// Creates an array of elements split into groups the length of size.
    /// If array can’t be split evenly, the final chunk will be the remaining elements.
    ///
    /// - parameter array: to chunk
    /// - parameter size: size of each chunk 每组大小
    /// - returns: array elements chunked
    func chunk(size: Int = 1) -> [[Element]] {
        var result = [[Element]]()
        var chunk = -1
        for (index, elem) in self.enumerated() {
            if index % size == 0 {
                result.append([Element]())
                chunk += 1
            }
            result[chunk].append(elem)
        }
        return result
    }
    
    /// Description
    ///
    /// - Parameter map: uniqueSet
    /// - Returns: unique Array
    func uniqueSet<T: Hashable> (map: ((Element) -> (T))) -> [Element] {
        var set = Set<T>() // the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() // keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
}

public typealias Byte = UInt8
public extension Array where Iterator.Element == Byte{
    //转换为16进制字符串
    func toHexString(_ separator: String = "") -> String {
        return self.lazy.reduce("") {
            var str = String($1, radix: 16)
            if str.count == 1 {
                str = "0" + str
            }
            return $0 + "\(separator)\(str)"
        }
    }
    
    //转换为16进制数组
    func toHexArray(_ value: [Byte]) -> [String] {
        return value.map { String(format: "%02x", $0) }
    }

    
}
