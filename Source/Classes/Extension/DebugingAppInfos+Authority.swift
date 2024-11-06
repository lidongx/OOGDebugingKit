//
//  DebugingAppInfos+Auth.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/24.
//

import Foundation
import AVFoundation
import AppTrackingTransparency
import UserNotifications
//import Photos
//import Contacts
//import EventKit
//import CoreLocation

extension DebugingAppInfos {
    /*
    func getCameraAuthority() -> String {
        var authority = ""
        let mediaType = AVMediaType.video // 读取媒体类型
        let authStatus = AVCaptureDevice.authorizationStatus(for: mediaType) // 读取设备授权状态
        switch authStatus {
        case .notDetermined:
            authority = "未决定"
        case .restricted:
            authority = "无法访问摄像"
        case .denied:
            authority = "不允许"
        case .authorized:
            authority = "已允许"
        @unknown default:
            break
        }
        return authority
    }
    
    func getMicrophoneAuthority() -> String {
        var authority = ""
        let mediaType = AVMediaType.audio // 读取媒体类型
        let authStatus = AVCaptureDevice.authorizationStatus(for: mediaType) // 读取设备授权状态
        switch authStatus {
        case .notDetermined:
            authority = "未决定"
        case .restricted:
            authority = "无法访问麦克风"
        case .denied:
            authority = "不允许"
        case .authorized:
            authority = "已允许"
        @unknown default:
            break
        }
        return authority
    }
    
    func getPhotoAlbumAuthority() -> String {
        var authority = ""
        let state = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch state {
        case .notDetermined:
            authority = "未决定"
        case .restricted:
            authority = "无法访问相册"
        case .denied:
            authority = "不允许"
        case .authorized:
            authority = "已允许"
        case .limited:
            authority = "受限访问"
        @unknown default:
            authority = "Unknown"
        }
        return authority
    }
    
    ///通讯录权限
    func getAddressBookAuthority() -> String {
        var authority = ""
        let state = CNContactStore.authorizationStatus(for: .contacts)
        switch state {
        case .notDetermined:
            authority = "未决定"
        case .restricted:
            authority = "无法访问通讯录"
        case .denied:
            authority = "不允许"
        case .authorized:
            authority = "已允许"
        case .limited:
            authority = "受限访问"
        @unknown default:
            authority = "Unknown"
        }
        return authority
    }
    
    ///日历权限
    func getCalendarAuthority() -> String {
        var authority = ""
        let state = EKEventStore.authorizationStatus(for: .event)
        switch state {
        case .notDetermined:
            authority = "未决定"
        case .restricted:
            authority = "无法访问日历"
        case .denied:
            authority = "不允许"
        case .fullAccess:
            authority = "完全访问"
        case .writeOnly:
            authority = "只读"
        case .authorized:
            authority = "已允许"
        @unknown default:
            authority = "Unknown"
        }
        return authority
    }
    
    //提醒权限
    func getReminderAuthority() -> String {
        var authority = ""
        let state = EKEventStore.authorizationStatus(for: .reminder)
        switch state {
        case .notDetermined:
            authority = "未决定"
        case .restricted:
            authority = "无法访问日历"
        case .denied:
            authority = "不允许"
        case .fullAccess:
            authority = "完全访问"
        case .writeOnly:
            authority = "只读"
        case .authorized:
            authority = "已允许"
        @unknown default:
            authority = "Unknown"
        }
        return authority
    }
    
    //获取位置权限
    func getNotiAuthority()  -> String {
        let b = CLLocationManager.locationServicesEnabled()
        return b ? "开启":"未开启"
    }
    */
    
    //获取ATT权限
    static func getATTAuthority() -> String {
        var authority = ""
        let state = ATTrackingManager.trackingAuthorizationStatus
        switch state {
        case .notDetermined:
            authority = "未决定"
        case .restricted:
            authority = "不能访问ATT"
        case .denied:
            authority = "不允许"
        case .authorized:
            authority = "已允许"
        @unknown default:
            authority = "Unknown"
        }
        return authority
    }
    
    //获取通知权限
    static func  getNotiAuthority() async -> String {
        let setting = await UNUserNotificationCenter.current().notificationSettings()
        let state = setting.authorizationStatus
        var authority = ""
        switch state {
           case .authorized:
               authority = "已允许"
           case .denied:
               authority = "不允许"
           case .notDetermined:
               authority = "未决定"
           default:
               authority = "Unknown"
        }
        return authority
    }
}
