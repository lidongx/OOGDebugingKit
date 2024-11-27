# FIREvents

FIREvents是统一事件库，支持向Amplitude，AppsFlyer，Firebase，MixPanel和Singular发送事件

### 特点

1. 只负责事件发送，不负责事件库的初始化
2. 接口统一，后期添加事件平台只需要实现Adapter即可，业务侧代码改动很小，只需要添加新平台的枚举值即可
3. 按需引入，不需要的平台不需要引入对应的库，减少包体积
4. 对旧版FIREvents完美兼容，业务侧改动很小，只需要添加事件平台的枚举值即可
5. 对MPEvent的registerSuperProperties完美兼容

### 使用

1. 在Podfile中添加FIREvents和需要接入平台的Adapter

```ruby
# 只引入Firebase
pod 'FIREvents', '~> 6.3.0', subspecs: ["Core", "FirebaseAdapter"]

# 全部引入
# 特别注意：MixPanel分别有MixPanelAdapter和MixPanelSwiftAdapter，如果之前用的是OC版本，则引入MixPanelAdapter，否则引入MixPanelSwiftAdapter。两个版本不兼容
# 如果之前引入的MixPanel OC版本，则引入MixPanelAdapter
# 如果之前引入的MixPanel Swift版本，则引入MixPanelSwiftAdapter
pod 'FIREvents', '~> 6.3.0', subspecs: ["Core", "FirebaseAdapter", "MixPanelAdapter", "AppsFlyerAdapter", "AmplitudeAdapter", "SingularAdapter"]
```

2. SPM 引入
```
dependencies: [
   .package(url: "https://github.com/retro-labs/iOS-FIREvents.git", .upToNextMajor(from: "6.3.0"))
]
```
3. 在AirTable上导出的Events.swift文件中，添加事件名称映射表和事件平台枚举值

```swift
// 可选，以onboarding_started为例
public static func eventNameMapping(platform: Platform) -> [FIREvents.Onboarding : String]? {
    if platform == .mixPanel {
        return [
            .onboarding_started: "OB Startd"
        ]
    } else if platform == .appsFlyer {
        return [
            .onboarding_started: "onboarding started"
        ]
    }
    return nil
}

// 必选，以该Category下的所有Events都需要发送到Firebase和MixPanel为例
public var platforms: Set<Platform> {
    [.firebase, .mixPanel]
}
```

3. 如果之前有调用MPEvent设置用户属性的方法，可以用以下方法替换

```swift
/// 设置用户属性
FIREvents.setUserPropertie(_: [String: Any?], platforms: Set<Platform>)
/// 设置用户属性（只允许设置一次）
FIREvents.setUserPropertiesOnce(_: [String: Any?], platforms: Set<Platform>)
/// 清空某个用户属性
FIREvents.clearUserProperty(_: String, platforms: Set<Platform>)
/// 清空用户属性
FIREvents.clearUserProperties(platforms: Set<Platform>)
```

### 特别注意

1. 接入后需要移除原有MixPanel发送Event逻辑，避免重复发送。
2. FIREvents.hookEvents中手动发送的EventName如果与hook的EventName相同，需要设置hookEnable，避免陷入死循环
3. 之前为了兼容Firebase平台，将字符串数组改为字符串类型的参数，在propertieTypes中都改会[String].self，FIREvents会根据平台特性发送字符串数组或字符串，业务端无需关注

### Changelog

### 6.2.10

- 对Mixpanel库依赖改成对MPEvent库的依赖
- 移除FacebookAdapter

### 6.2.8

- sendEvents添加hookEnable参数，避免在hook中发送同样名称的Event陷入死循环

#### 6.2.0

- 修复几处拼写错误
- 添加对Singular的支持
