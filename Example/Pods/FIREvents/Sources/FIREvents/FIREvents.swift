//
//  FIREvents.swift
//  FIREvents
//
//  Created by DongDong on 2023/8/14.
//

import Foundation

final public class FIREvents {

    // MARK: Public Properties

    @available(*, deprecated, message: "Use logs(platform:) instead")
    /// 获取记录的事件（兼容问题，只支持firebase平台）
    public static var eventLogs: [(name: String, param: [String: Any]?)] {
        logs(platform: .firebase)
    }

    // MARK: Public Methods

    /// 设置是否记录发送事件
    public static func setEnableLog(_ enable: Bool = false) {
        enableLog = enable
    }

    /// 获取记录的事件
    public static func logs(platform: Platform = .firebase) -> [(name: String, param: [String: Any]?)] {
        adapters[platform]?.logs.array ?? []
    }

    /// 清空记录的事件
    public static func clearLogs(platform: Platform = .firebase) {
        adapters[platform]?.clearLogs()
    }

    /// 设置事件回调
    public static func hookEvents(event: ((_ name: String, _ param: [String: Any]?) -> Void)?) {
        hookHandle = event
    }

    /// 发送事件
    /// - Parameters:
    ///   - event: 事件名称
    ///   - param: 事件参数
    ///   - hookEnable: 是否hook
    public static func sendEvents<T: FIREventSendable>(event: T, param: [T.Parameter: Any]?, hookEnable: Bool = true) {
        for platform in event.platforms {
            register(platform)
            let adapter = adapters[platform]
            adapter?.sendEvent(event, param: param)
        }

        var paramDict: [String: Any]?
        if let param {
            var dict = [String: Any]()
            for (key, value) in param {
                dict[key.rawValue] = value
            }
            paramDict = dict
        }

        if hookEnable {
            hookHandle?(event.rawValue, paramDict)
        }
    }

    /// 发送事件
    /// - Parameters:
    ///   - event: 事件名称
    ///   - param: 事件参数
    ///   - platforms: 发送平台
    public static func sendEvent(event: String, param: [String: Any]?, platforms: Set<Platform>) {
        for platform in platforms {
            register(platform)
            let adapter = adapters[platform]
            adapter?.sendEvent(event, param: param)
        }

        var paramDict: [String: Any]?
        if let param {
            var dict = [String: Any]()
            for (key, value) in param {
                dict[key] = value
            }
            paramDict = dict
        }
        hookHandle?(event, paramDict)
    }

    /// 设置用户属性
    /// - Parameters:
    ///   - name: 属性名称
    ///   - value: 属性值
    public static func setUserProperty<T: FIRUserPropertySendable>(name: T, value: Any? = nil) {
        for platform in name.platforms {
            register(platform)
            let adapter = adapters[platform]
            adapter?.setUserProperty(name, value: value)
        }
    }

    /// 设置用户属性
    /// - Parameters:
    ///   - name: 属性名称
    ///   - value: 属性值
    ///   - platforms: 平台
    public static func setUserProperty(name: String, value: Any?, platforms: Set<Platform>) {
        for platform in platforms {
            register(platform)
            let adapter = adapters[platform]
            adapter?.setUserProperty(name, value: value)
        }
    }

    /// 设置用户属性
    /// - Parameters:
    ///   - userProperties: 用户属性
    ///   - platforms: 平台
    public static func setUserProperties(_ userProperties: [String: Any?], platforms: Set<Platform>) {
        for platform in platforms {
            register(platform)
            let adapter = adapters[platform]
            adapter?.setUserProperties(userProperties)
        }
    }

    /// 设置用户属性（用户生命周期内只生效一次）
    /// - Parameters:
    ///   - name: 属性名称
    ///   - value: 属性值
    ///   - platforms: 平台
    public static func setUserPropertyOnce(name: String, value: Any?, platforms: Set<Platform>) {
        for platform in platforms {
            register(platform)
            let adapter = adapters[platform]
            adapter?.setUserPropertyOnce(name, value: value)
        }
    }

    /// 设置用户属性（用户生命周期内只生效一次）
    /// - Parameters:
    ///   - userProperties: 用户属性
    ///   - platforms: 平台
    public static func setUserPropertiesOnce(_ userProperties: [String: Any?], platforms: Set<Platform>) {
        for platform in platforms {
            register(platform)
            let adapter = adapters[platform]
            adapter?.setUserPropertiesOnce(userProperties)
        }
    }

    /// 清空用户属性
    /// - Parameter name: 属性名称
    public static func clearUserProperty<T: FIRUserPropertySendable>(name: T) {
        for platform in name.platforms {
            register(platform)
            let adapter = adapters[platform]
            adapter?.clearUserProperty(name)
        }
    }

    /// 清空用户属性
    /// - Parameters:
    ///   - name: 属性名称
    ///   - platforms: 平台
    public static func clearUserProperty(name: String, platforms: Set<Platform>) {
        for platform in platforms {
            let adapter = adapters[platform]
            adapter?.clearUserProperty(name)
        }
    }

    /// 清空用户属性，如果names为nil，则清空用户所有属性
    /// - Parameters:
    ///   - names: 用户属性
    ///   - platforms: 平台
    public static func clearUserProperties(_ names: [String]? = nil, platforms: Set<Platform>) {
        for platform in platforms {
            let adapter = adapters[platform]
            adapter?.clearUserProperties(names)
        }
    }

    // MARK: Private Properties

    /// 是否记录发送事件
    private static var enableLog = false {
        didSet {
            for (_, adapter) in adapters {
                adapter.enableLog = enableLog
            }
        }
    }

    /// 缓存的Adapter
    private static var adapters = ThreadSafeDictionary<Platform, Adapter.Type>()

    /// 事件回调（不会对数据进行任何处理）
    private static var hookHandle: ((_ name: String, _ param: [String: Any]?) -> Void)?

    /// 注册Adapter
    private static func register(_ platform: Platform) {
        guard !adapters.keys.contains(platform) else { return }

        guard let adapter = platform.adapterClass else {
            assertionFailure("\(platform.adapter)未引入")
            return
        }
        adapter.enableLog = enableLog
        adapters[platform] = adapter
    }
}

extension FIREvents {

    public struct EnumType {}
    public struct UserProperty {}
}
