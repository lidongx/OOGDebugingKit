//
//  NSObject+Extension.swift
//  DemoForTest
//
//  Created by lidong on 2023/9/7.
//

import UIKit

/* 使用
 var number: Int {
     get {
         return objectMap["number"] as? Int ?? 0
     }
     set {
         objectMap["number"] = newValue
     }
 }
 */

//其它的扩展里面增加属性可以使用这个字典
public extension NSObject{
    //运行时存储Key
    private struct AssociatedKeys{
        static var objectKey = "objectKey"
    }
        
    @objc dynamic var objectMap: [String:Any] {
        set{
            objc_setAssociatedObject(self,AssociatedKeys.objectKey.unsafeRawPointer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get{
            if let dic = objc_getAssociatedObject(self, AssociatedKeys.objectKey.unsafeRawPointer) as? [String:Any]{
                return dic
            }
            let dic = [String:Any]()
            self.objectMap = dic
            return dic
        }
    }
}

