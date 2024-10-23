//
//  FloatingData.swift
//  TestSPM
//
//  Created by lidong on 2024/4/12.
//

import Foundation
import UIKit
import Components

class DebugingComponents {
    static var sections:[Section] = [
        .init(title: "常用工具", types: [
            .appInfo,
            .events
        ])
    ]
}


struct Section {
    var title:String
    var types:[ComponentType]
    init(title: String, types: [ComponentType]) {
        self.title = title
        self.types = types
    }
}


enum ComponentType{
   case appInfo
   case events
    
    var title:String{
        switch self {
        case .appInfo:
            return "App信息"
        case .events:
            return "Events事件"
        }
    }
    
    var icon:String{
        switch self {
        case .appInfo:
            return "appinfo.png"
        case .events:
            return "events.png"
        }
    }
    
    var viewController: UIViewController? {
        switch self {
        case .appInfo:
            return DebugingAppInfoViewController()
        case .events:
            return DebugingEventsViewController()
        }
    }
    
}

