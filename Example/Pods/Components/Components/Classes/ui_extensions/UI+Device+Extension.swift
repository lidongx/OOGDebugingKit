//
//  UIDevice+Extension.swift
//  OOG104
//
//  Created by maning on 2020/1/22.
//  Copyright © 2020 maning. All rights reserved.
//

import UIKit

import CoreMotion

import CoreTelephony
import SystemConfiguration.CaptiveNetwork


public extension UIDevice {
    
    //MARK: - Formatter MB only
    func unitFormatter(_ bytes: Int64, _ showUnit: ByteCountFormatter.Units, _ showStyle: ByteCountFormatter.CountStyle, _ isShowUnit: Bool = false) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = showUnit //返回字符串的显示单位
        formatter.countStyle = showStyle  //返回字符串的计算单位,1000进制（file或decimal）或者1024进制（binary）
        formatter.includesUnit = isShowUnit
        return formatter.string(fromByteCount: bytes) as String
    }
        
    //MARK: - Get raw value
    var totalDiskSpaceInBytes:Int64 {
        get {
            do {
                guard let totalDiskSpaceInBytes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemSize] as? Int64 else {
                    return 0
                }
                return totalDiskSpaceInBytes
            } catch {
                return 0
            }
        }
    }
    
    var freeDiskSpaceInBytes:Int64 {
        get {
            if #available(iOS 11.0, *) {
                if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                    return space
                } else {
                    return 0
                }
            } else {
                guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
                    let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value else { return 0 }
                return freeSpace
            }
        }
    }
    
    var usedDiskSpaceInBytes:Int64 {
        get {
            let usedSpace = totalDiskSpaceInBytes - freeDiskSpaceInBytes
            return usedSpace
        }
    }
    
    //MARK: - Get StringValue Method 获取总的磁盘空间 单位MB 字符串
    func totalDiskSpace(_ unit: ByteCountFormatter.Units = .useMB, _ style: ByteCountFormatter.CountStyle = .decimal, _ isShowUnit: Bool = true) -> String {
        return unitFormatter(totalDiskSpaceInBytes, unit, style, isShowUnit)
    }

    // 获取剩余磁盘空间 单位MB 字符串
    func freeDiskSpace(_ unit: ByteCountFormatter.Units = .useMB, _ style: ByteCountFormatter.CountStyle = .decimal, _ isShowUnit: Bool = true) -> String {
        return unitFormatter(freeDiskSpaceInBytes, unit, style, isShowUnit)
    }

    // 获取使用了的磁盘空间 单位MB 字符串
    func usedDiskSpace(_ unit: ByteCountFormatter.Units = .useMB, _ style: ByteCountFormatter.CountStyle = .decimal, _ isShowUnit: Bool = true) -> String {
        return unitFormatter(usedDiskSpaceInBytes, unit, style, isShowUnit)
    }
    
    //MARK: - Get NumberValue Method  获取总的磁盘空间 单位MB float数字
    func totalDiskSpaceNumber(_ unit: ByteCountFormatter.Units = .useMB, _ style: ByteCountFormatter.CountStyle = .decimal) -> Float {
        return unitFormatter(totalDiskSpaceInBytes, unit, style).description.replacingOccurrences(of: ",", with: "").floatValue
    }

    // 获取剩余磁盘空间 单位MB float数字
    func freeDiskSpaceNumber(_ unit: ByteCountFormatter.Units = .useMB, _ style: ByteCountFormatter.CountStyle = .decimal) -> Float {
        return unitFormatter(freeDiskSpaceInBytes, unit, style).description.replacingOccurrences(of: ",", with: "").floatValue
    }

    // 获取使用了的磁盘空间 单位MB float数字
    func usedDiskSpaceNumber(_ unit: ByteCountFormatter.Units = .useMB, _ style: ByteCountFormatter.CountStyle = .decimal) -> Float {
        return unitFormatter(usedDiskSpaceInBytes, unit, style).description.replacingOccurrences(of: ",", with: "").floatValue
    }
}


extension UIDevice{
    //获取国家的名字
    public var country: String {
        if let regionCode = Locale.current.regionCode {
            if let country = (Locale(identifier: "en_US") as NSLocale).displayName(forKey: .countryCode, value: regionCode) {
                return country
            }
        }
        
        let currentLocale = NSLocale.system as NSLocale
        var languageCode = "en_US"
        
        if let language = NSLocale.preferredLanguages.first {
            languageCode = language
        }
        
        let country = currentLocale.displayName(forKey: .identifier, value: languageCode)
        
        return country ?? "US"
    }
    
}


 extension UIDevice {
   //获取设备名
   public var deviceName: String {
       var systemInfo = utsname()
       uname(&systemInfo)
       let machineMirror = Mirror(reflecting: systemInfo.machine)
       let identifier = machineMirror.children.reduce("") { identifier, element in
           guard let value = element.value as? Int8 , value != 0 else { return identifier }
           return identifier + String(UnicodeScalar(UInt8(value)))
       }
       
       switch identifier {
       case "iPod5,1":                                 return "iPod Touch 5"
       case "iPod7,1":                                 return "iPod Touch 6"
       case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
       case "iPhone4,1":                               return "iPhone 4s"
       case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
       case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
       case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
       case "iPhone7,2":                               return "iPhone 6"
       case "iPhone7,1":                               return "iPhone 6 Plus"
       case "iPhone8,1":                               return "iPhone 6s"
       case "iPhone8,2":                               return "iPhone 6s Plus"
       case "iPhone8,4":                               return "iPhone SE (1st generation)"
       case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
       case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
       case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
       case "iPhone10,5", "iPhone10,2":                return "iPhone 8 Plus"
       case "iPhone10,3", "iPhone10,6":                return "iPhone X"
       case "iPhone11,2":                              return "iPhone XS"
       case "iPhone11,4", "iPhone11,6":                return "iPhone XS MAX"
       case "iPhone11,8":                              return "iPhone XR"
       case "iPhone12,1":                              return "iPhone 11"
       case "iPhone12,3":                              return "iPhone 11 pro"
       case "iPhone12,5":                              return "iPhone 11 Pro Max"
       case "iPhone12,8":                              return "iPhone SE (2nd generation)"
       case "iPhone13,1":                              return "iPhone 12 mini"
       case "iPhone13,2":                              return "iPhone 12"
       case "iPhone13,3":                              return "iPhone 12 Pro"
       case "iPhone13,4":                              return "iPhone 12 Pro Max"
       case "iPhone14,4":                              return "iPhone 13 mini"
       case "iPhone14,5":                              return "iPhone 13"
       case "iPhone14,2":                              return "iPhone 13 Pro"
       case "iPhone14,3":                              return "iPhone 13 Pro Max"
       case "iPhone14,6":                              return "iPhone SE (3rd generation)"
       case "iPhone14,7":                              return "iPhone 14"
       case "iPhone14,8":                              return "iPhone 14 Plus"
       case "iPhone15,2":                              return "iPhone 14 Pro"
       case "iPhone15,3":                              return "iPhone 14 Pro Max"
       case "iPhone15,4":                              return "iPhone 15"
       case "iPhone15,5":                              return "iPhone 15 Plus"
       case "iPhone16,1":                              return "iPhone 15 Pro"
       case "iPhone16,2":                              return "iPhone 15 Pro Max"
           
           
       case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
       case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
       case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
       case "iPad6,11", "iPad6,12":                    return "iPad 5"
       case "iPad7,5", "iPad7,6":                      return "iPad 6"
       case "iPad7,11", "iPad7,12":                    return "iPad 7"
       case "iPad11,6", "iPad11,7":                    return "iPad 8"
       case "iPad12,1", "iPad12,2":                    return "iPad 9"

       case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
       case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
       case "iPad11,3", "iPad11,4":                    return "iPad Air 3"
       case "iPad13,1", "iPad13,2":                    return "iPad Air 4"
       case "iPad13,16", "iPad13,17":                  return "iPad Air 5"
       
       case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
       case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
       case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
       case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
       case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
       case "iPad14,1", "iPad14,2":                    return "iPad Mini 6"
       case "iPad6,7", "iPad6,8", "iPad6,3", "iPad6,4", "iPad7,1", "iPad7,2", "iPad7,3", "iPad7,4", "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4", "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8", "iPad8,9", "iPad8,10", "iPad8,11", "iPad8,12":         return "iPad Pro"
       case "AppleTV5,3":                              return "Apple TV"
       case "AppleTV6,2":                              return "Apple TV 4K"
       case "i386", "x86_64" , "arm64":                return "Simulator"
       default:                                        return identifier
       }
   }
   
}
