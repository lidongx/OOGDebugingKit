//
//  DebugingEvents.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/23.
//

import Foundation

public enum DebugingEventsPlatform{
    case mixpanel
    case firebase
}


class DebugingEvents {
    static var mixpanelEvents:[DebugingEvent] = []
    static var firebaseEvents:[DebugingEvent] = []
    
    static var notificationKey = "DebugingEventsNotificationKey"
     
    static func addEvent(name:String,param:[String:Any],platform:DebugingEventsPlatform){
        
        if platform == .mixpanel {
            mixpanelEvents.append(.init(type: .event ,name: name, params: param))
        } else if platform == .firebase {
            firebaseEvents.append(.init(type: .event ,name: name, params: param))
        }
    }
    
    static func addUserProperty(name:String,value:Any,platform:DebugingEventsPlatform){
        let valueString = "\(value)"
        if valueString.isEmpty {
            if platform == .mixpanel {
                mixpanelEvents.append(
                    .init(type:.userProperty,name: "\(name)", params: [:])
                )
            } else if platform == .firebase {
                firebaseEvents.append(
                    .init(type:.userProperty,name: "\(name)", params: [:])
                )
            }
        } else {
            if platform == .mixpanel {
                mixpanelEvents.append( .init(type:.userProperty,name: "\(name):\(value)",
                            params: [:])
                )
            } else if platform == .firebase {
                firebaseEvents.append( .init(type:.userProperty,name: "\(name):\(value)",
                            params: [:])
                )
            }
        }
    }
    
    static func addUserProperty(name:String,platform:DebugingEventsPlatform){
        addUserProperty(name: name, value: "",platform: platform)
    }
}

enum DebugingEventType {
    case event
    case userProperty
}

class DebugingEvent {
    var name:String
    var params:[String:Any]
    var type:DebugingEventType
    var items:[String] = []
    init(type:DebugingEventType, name: String, params: [String : Any]) {
        self.type = type
        self.name = name
        self.params = params
        let keys = params.keys.sorted()
        for key in keys {
            if let value = params[key] {
                let str:String = "\(key):\(value)"
                items.append(str)
            }
        }
    }
}
