//
//  DebugingAppInfos+Extension.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/23.
//

import Foundation
import Components
import MachO

extension DebugingAppInfos {
    static func setSubscription(_ isActive: Bool) {
        let value:String = isActive ? "已订阅" : "未订阅"
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
    
    static func setAppID(_ value:String) {
        for section in sections where section.sectionType == .ids {
            if let index = section.items.firstIndex(where: { $0.type == .appID }) {
                section.items[index].value = value
            } else {
                section.items.append(.init(type: .appID, value: value))
            }
        }
    }
    
    static func setMixpanelToken(_ value:String) {
        for section in sections where section.sectionType == .ids {
            if let index = section.items.firstIndex(
                where: { $0.type == .mixpanelToken
                }) {
                section.items[index].value = value
            } else {
                section.items.append(.init(type: .mixpanelToken, value: value))
            }
        }
    }
    
    static func setMixpanelDeviceID(_ value:String) {
        for section in sections where section.sectionType == .ids {
            if let index = section.items.firstIndex(
                where: { $0.type == .mixpanelDeviceID
                }) {
                section.items[index].value = value
            } else {
                section.items
                    .append(.init(type: .mixpanelDeviceID, value: value))
            }
        }
    }
    
    static func setStagsigAPIKey(_ value:String) {
        for section in sections where section.sectionType == .ids {
            if let index = section.items.firstIndex(
                where: { $0.type == .statsigApiKey
                }) {
                section.items[index].value = value
            } else {
                section.items
                    .append(.init(type: .statsigApiKey, value: value))
            }
        }
    }
    
    static func setAdaptyKey(_ value:String) {
        for section in sections where section.sectionType == .ids {
            if let index = section.items.firstIndex(
                where: { $0.type == .adaptyKey
                }) {
                section.items[index].value = value
            } else {
                section.items
                    .append(.init(type: .adaptyKey, value: value))
            }
        }
    }

    static func setAdaptyLevel(_ value:String) {
        for section in sections where section.sectionType == .ids {
            if let index = section.items.firstIndex(
                where: { $0.type == .adaptyLevel
                }) {
                section.items[index].value = value
            } else {
                section.items
                    .append(.init(type: .adaptyLevel, value: value))
            }
        }
    }
    
    static func setSupperWallKey(_ value:String) {
        for section in sections where section.sectionType == .ids {
            if let index = section.items.firstIndex(
                where: { $0.type == .supperWallKey
                }) {
                section.items[index].value = value
            } else {
                section.items
                    .append(.init(type: .supperWallKey, value: value))
            }
        }
    }
    
    static func setOneSignalToken(_ value:String){
        for section in sections where section.sectionType == .ids {
            if let index = section.items.firstIndex(
                where: { $0.type == .oneSignalToken
                }) {
                section.items[index].value = value
            } else {
                section.items
                    .append(.init(type: .oneSignalToken, value: value))
            }
        }
    }
    
    static func setSingularKey(_ value:String){
        for section in sections where section.sectionType == .ids {
            if let index = section.items.firstIndex(
                where: { $0.type == .singularKey
                }) {
                section.items[index].value = value
            } else {
                section.items
                    .append(.init(type: .singularKey, value: value))
            }
        }
    }
    
    static func setSingularSecrectKey(_ value:String){
        for section in sections where section.sectionType == .ids {
            if let index = section.items.firstIndex(
                where: { $0.type == .singularSecretKey
                }) {
                section.items[index].value = value
            } else {
                section.items
                    .append(.init(type: .singularSecretKey, value: value))
            }
        }
    }
    
    static func setNotiState(_ value: String){
        for section in sections where section.sectionType == .permissions {
            if let index = section.items.firstIndex(
                where: { $0.type == .notiAuth
                }) {
                section.items[index].value = value
            } else {
                section.items
                    .append(.init(type: .notiAuth, value: value))
            }
        }
    }
    
    static func setATTState(_ value: String){
        for section in sections where section.sectionType == .permissions {
            if let index = section.items.firstIndex(
                where: { $0.type == .attAuth
                }) {
                section.items[index].value = value
            } else {
                section.items
                    .append(.init(type: .attAuth, value: value))
            }
        }
    }
    
    static func setAppMemoryUsage(_ value:String){
        for section in sections where section.sectionType == .appInfo {
            if let index = section.items.firstIndex(
                where: { $0.type == .appMemoryUsage
                }) {
                section.items[index].value = value
            } else {
                section.items
                    .append(.init(type: .appMemoryUsage, value: value))
            }
        }
    }
    
    static func setAppDiskSpaceUsage(_ value:String) {
        for section in sections where section.sectionType == .appInfo {
            if let index = section.items.firstIndex(
                where: { $0.type == .appDiskSpaceUsage
                }) {
                section.items[index].value = value
            } else {
                section.items
                    .append(.init(type: .appDiskSpaceUsage, value: value))
            }
        }
    }
    
    static func setAppFrameRate(_ value:String) {
        for section in sections where section.sectionType == .appInfo {
            if let index = section.items.firstIndex(
                where: { $0.type == .fps
                }) {
                section.items[index].value = value
            } else {
                section.items
                    .append(.init(type: .fps, value: value))
            }
        }
    }
}

extension DebugingAppInfos {
    static func updateNetworkState(){
        let state = NetworkMonitor.shared.connectType
        var value = "未知"
        if state == .cellular {
            value = "窝峰"
        } else if state == .wifi {
            value = "Wifi"
        }
        if !NetworkMonitor.shared.connected {
            value = "未连接"
        }else {
            value = "已连接(\(value))"
        }
        for section in sections where section.sectionType == .phoneInfo {
            if let index = section.items.firstIndex(
                where: { $0.type == .networkStatus
                }) {
                section.items[index].value = value
            } else {
                section.items.append(.init(type: .networkStatus, value: value))
            }
        }
    }
    
    static func getAppMemoryUsage()->String{
        // 调用获取内存
        if let memoryUsage = getUsage() {
            return "\(memoryUsage / 1024 / 1024) MB"
        } else {
            return "未能获取到"
        }
    }
    
    static func getUsage() -> Int64? {
        var memoryUsageInByte: Int64 = 0
        var vmInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<integer_t>.size)
        let kernelReturn = withUnsafeMutablePointer(to: &vmInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        
        if kernelReturn == KERN_SUCCESS {
            memoryUsageInByte = Int64(vmInfo.phys_footprint)
            print("Memory in use (in bytes): \(memoryUsageInByte)")
        } else {
            print("Error with task_info(): \(String(cString: mach_error_string(kernelReturn)))")
        }
        
        return memoryUsageInByte
    }
    
    
    
    static func getAppBundleSize() -> UInt64 {
        // 获取应用的沙盒根目录
        let bundleURL = Bundle.main.bundleURL
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
        let tmpURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        
        // 计算各个目录的大小
        let bundleSize = directorySize(at: bundleURL)
        let documentsSize = directorySize(at: documentsURL)
        let librarySize = directorySize(at: libraryURL)
        let tmpSize = directorySize(at: tmpURL)
        
        // 总大小
        return bundleSize + documentsSize + librarySize + tmpSize
    }
    
    static func directorySize(at url: URL) -> UInt64 {
        var size: Int = 0
        if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.fileSizeKey], options: [], errorHandler: nil) {
            for case let fileURL as URL in enumerator {
                size += (try? fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0) ?? 0
            }
        }
        return UInt64(size)
    }

    
    static func getAppDiskSpaceSize()->String{
        // 调用获取应用包大小
        let appSize = getAppBundleSize()
        return "\(appSize / 1024 / 1024) MB"
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
