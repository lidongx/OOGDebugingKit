//
//  DebugingAppInfo.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/22.
//

import Foundation
import Components
import UIKit

class DebugingAppInfos {
    static var sections:[DebugingAppInfoSection] = [
        .init(section: .phoneInfo, items: [
            .init(type: .device, value: UIDevice.current.deviceName),
            .init(type: .systemVersion, value: UIDevice.current.systemName+UIDevice.current.systemVersion),
            .init(type: .country, value: UIDevice.current.country),
            .init(type: .freeDiskSpace, value: UIDevice.current.freeDiskSpace()),
            .init(type: .usedDiskSpace, value: UIDevice.current.usedDiskSpace()),
            .init(type: .totalDiskSpace, value: UIDevice.current.totalDiskSpace()),
        ]),

        .init(section: .appInfo, items: [
            .init(type: .appIdentifier, value: Bundle.main.bundleIdentifier),
            .init(type: .appVersion, value: Bundle.main.versionNumber),
            .init(type: .appBuildVersion, value: Bundle.main.buildNumber),
        ]),

        .init(section: .permissions, items: [
            .init(type: .appIdentifier, value: Bundle.main.bundleIdentifier),
            .init(type: .appVersion, value: Bundle.main.versionNumber),
            .init(type: .appBuildVersion, value: Bundle.main.buildNumber),
        ]),

        .init(section: .ids, items: [
            .init(type: .idfa, value: UIDevice.current.idfa),
            .init(type: .idfv, value: UIDevice.current.idfv),
        ]),

        .init(section: .custom, items: [
                
        ])
    ]
    
    static func setAppID(_ appID:String) {
        for section in sections where section.sectionType == .appInfo {
            if let index = section.items.firstIndex(where: { $0.type == .appID }) {
                section.items[index].value = appID
            } else {
                section.items.append(.init(type: .appID, value: appID))
            }
        }
    }
    
    static func setSubscription(_ isActive: Bool) {
        let value:String = isActive ? "True" : "False"
        for section in sections where section.sectionType == .appInfo {
            if let index = section.items.firstIndex(
                where: { $0.type == .subscription
                }) {
                section.items[index].value = value
            } else {
                section.items.append(.init(type: .subscription, value: value))
            }
        }
    }
    
    static func setCustom(name:String, value:String){
        for section in sections where section.sectionType == .custom {
            if let index = section.items.firstIndex(
                where: { $0.type == .custom(name: name)
                }) {
                section.items[index].value = value
            } else {
                section.items
                    .append(.init(type: .custom(name: name), value: value))
            }
        }
    }
}


public enum AppInfoSectionType {
    case phoneInfo
    case appInfo
    case permissions
    case ids
    case custom
    
    var display:String {
        switch self {
        case .phoneInfo:
            "手机信息"
        case .appInfo:
            "APP信息"
        case .permissions:
            "权限"
        case .ids:
            "ID"
        case .custom:
            "自定义"
        }
    }
}

public enum AppInfoType:Hashable{
    case device
    case systemVersion
    case country

    case freeDiskSpace
    case usedDiskSpace
    case totalDiskSpace

    case appIdentifier
    case appVersion
    case appBuildVersion

    case appID
    case subscription
    case networkStatus
    case mixpanelDistinctID
    case mixpanelDeviceID
    
    case idfa
    case idfv
    
    case custom(name:String)
    
    public var displayName:String{
        switch self {
        case .device:
            "手机型号"
        case .systemVersion:
            "系统版本"
        case .country:
            "国家"
            
        case .appIdentifier:
            "Bundle ID"
        case .appVersion:
            "App Version"
        case .appBuildVersion:
            "App Build Version"
        case .idfa:
            "IDFA"
        case .idfv:
            "IDFV"

        case .freeDiskSpace:
            "剩余磁盘空间"
        case .usedDiskSpace:
            "磁盘使用空间"
        case .totalDiskSpace:
            "总的磁盘空间"
            
        case .appID:
            "APP ID"
        case .subscription:
            "订阅状态"
        case .networkStatus:
            "网络状态"
        case .mixpanelDistinctID:
            "Mixpanel Distinct ID"
        case .mixpanelDeviceID:
            "Mixpanel Device ID"
        
        case .custom(let name):
            name
        }
    }
}

public class DebugingAppInfoItem{
    public var type:AppInfoType
    public var value:String
    
    public init(type: AppInfoType, value: String) {
        self.type = type
        self.value = value
    }
}

public class DebugingAppInfoSection {
    public var sectionType:AppInfoSectionType
    public var items:[DebugingAppInfoItem]
    
    init(section:AppInfoSectionType, items: [DebugingAppInfoItem]) {
        self.sectionType = section
        self.items = items
    }
}
