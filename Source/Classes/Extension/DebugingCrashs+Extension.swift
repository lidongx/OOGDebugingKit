//
//  DebugingCrashs+Extension.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/25.
//

import Foundation

extension DebugingCrashs {
    static func indexOutofRangeCrash(){
        let array = [1, 2, 3]
        let _ = array[5]  // 这里会崩溃，因为索引 5 超出了数组范围
    }
    
    static func forcedUnwrappingCrash() {
        let optionalString: String? = nil
        let forcedUnwrappedString = optionalString!  // 这里会崩溃，因为 optionalString 是 nil
        print(forcedUnwrappedString)
    }
    
    static func nilDereferencingCrash(){
        class Person {
            var name: String?
        }
        let person: Person? = nil
        let _ = person!.name  // 这里会崩溃，因为 person 是 nil
    }
    
    static func divisionByZeroCrash() {
        let numbers = [10]
        let value = numbers[0] - 10
        let res = 10 / value  // 这里会崩溃，因为无法除以零
        print(res)
    }
    
    static var debugingCount:Int = 0
    
    static func raceConditionCrash() {
        for _ in 0...10 {
            DispatchQueue.global().async {
                for _ in 0...1000000{
                    debugingCount += 1
                }
            }
        }
    }
    
    static func loopFunc(){
        stackOverflowCrash()
    }
    
    static func stackOverflowCrash(){
        loopFunc()
    }
    
    static func outOfMemoryCrash(){
        var largeArray = [Int]()
        for i in 0...Int.max {
            largeArray.append(i)  // 这里可能导致内存不足崩溃
        }
    }
    
    static func invalidCastCrash(){
        let someObject: Any = "Hello"
        let _ = someObject as! Int  // 这里会崩溃，因为无法将 String 强制转换为 Int
    }
    
    static func keyValueObservingCrash(){
        class MyClass: NSObject {
            @objc dynamic var name: String = ""
        }

        let myObject = MyClass()
        myObject.removeObserver(myObject, forKeyPath: "name")  // 如果没有添加观察者，移除时会崩溃
    }
    
}


