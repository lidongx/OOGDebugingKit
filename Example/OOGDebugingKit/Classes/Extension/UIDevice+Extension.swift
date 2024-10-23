//
//  UIDevice+Extension.swift
//  TestSPM
//
//  Created by lidong on 2024/4/12.
//

import Foundation
import Components
import AdSupport
import UIKit
public extension UIDevice{
    
    var idfv:String{
        return identifierForVendor?.uuidString ?? ""
    }
    
    
    var idfa:String{
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
}
