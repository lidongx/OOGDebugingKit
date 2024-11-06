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
    
    static var environment:String {
        #if AppStoreEnv
            "App Store"
        #else
        #if DEBUG
            "Debug"
        #else
            "Release"
        #endif
        #endif
    }
    
    static var sections:[DebugingAppInfoSection] = [
        .init(section: .phoneInfo, items: [
            .init(type: .device, value: UIDevice.current.deviceName),
            .init(type: .systemVersion, value: UIDevice.current.systemName+UIDevice.current.systemVersion),
            .init(type: .country, value: UIDevice.current.country),
            .init(type: .networkStatus, value: "未知"),
            .init(type: .freeDiskSpace, value: UIDevice.current.freeDiskSpace()),
            .init(type: .usedDiskSpace, value: UIDevice.current.usedDiskSpace()),
            .init(type: .totalDiskSpace, value: UIDevice.current.totalDiskSpace()),
        ]),

        .init(section: .appInfo, items: [
            .init(type: .appIdentifier, value: Bundle.main.bundleIdentifier),
            .init(type: .appVersion, value: Bundle.main.versionNumber),
            .init(type: .appBuildVersion, value: Bundle.main.buildNumber),
            .init(type: .subscription, value: "未设置"),
            .init(type: .environment, value: DebugingAppInfos.environment),
            .init(type: .appMemoryUsage, value: "未设置"),
            .init(type: .appDiskSpaceUsage, value: "未设置"),
            .init(type: .fps, value: "未设置")

        ]),

        .init(section: .permissions, items: [
            .init(type: .notiAuth, value: "未设置"),
            .init(type: .attAuth, value: "未设置")
        ]),

        .init(section: .ids, items: [
            .init(type: .appID, value: "未设置"),
            .init(type: .mixpanelToken, value: "未设置"),
            .init(type: .mixpanelDeviceID, value: "未设置"),
            .init(type: .statsigApiKey, value: "未设置"),
            .init(type: .adaptyKey, value: "未设置"),
            .init(type: .adaptyLevel, value: "未设置"),
            .init(type: .supperWallKey, value: "未设置"),
            .init(type: .oneSignalToken, value: "未设置"),
            .init(type: .singularKey, value: "未设置"),
            .init(type: .singularSecretKey, value: "未设置"),
            
            .init(type: .idfa, value: UIDevice.current.idfa),
            .init(type: .idfv, value: UIDevice.current.idfv),
        ]),

        .init(section: .custom, items: [
            
        ])
    ]
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
    case networkStatus
    case freeDiskSpace
    case usedDiskSpace
    case totalDiskSpace

    case appIdentifier
    case appVersion
    case appBuildVersion
    case subscription
    case environment
    case appMemoryUsage
    case appDiskSpaceUsage
    case fps

    case appID
    case mixpanelToken
    case mixpanelDeviceID
    case statsigApiKey
    case adaptyKey
    case adaptyLevel
    case supperWallKey
    case oneSignalToken
    case singularKey
    case singularSecretKey
    
    case idfa
    case idfv
    
    
    case notiAuth
    case attAuth
    
    
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
        case .mixpanelToken:
            "Mixpanel Token"
        case .mixpanelDeviceID:
            "Mixpanel DeviceID"
        case .statsigApiKey:
            "Statsig APIKey"
        case .adaptyKey:
            "Adapty Key"
        case .adaptyLevel:
            "Adapty Level"
        case .supperWallKey:
            "SupperWall Key"
        case .oneSignalToken:
            "OneSignal Token"
        case .singularKey:
            "Singular Key"
        case .singularSecretKey:
            "Singular SecretKey"
        case .environment:
            "开发环境"
        case .notiAuth:
            "通知权限"
        case .attAuth:
            "ATT权限"
        
        case .custom(let name):
            name
        case .appMemoryUsage:
            "内存使用量"
        case .appDiskSpaceUsage:
            "App占磁盘空间"
        case .fps:
            "帧率"
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
