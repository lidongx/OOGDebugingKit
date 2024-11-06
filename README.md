# OOGDebugingKit

OOGDebugingKit是替换掉UI界面上debug,crash,events等等一些按钮。

## 使用

1. 通过Cocospod引用，在Podfile中添加Components
    ```
    pod 'Components','~> 0.1.10.3'
    ```
    
2. 通过Swift Package Manager在Package.swift添加依赖
    ```
    dependencies: [
        .package(url: "https://github.com/retro-labs/components-ios-swift.git", .upToNextMajor(from: "0.1.10.2"))
    ]
    ```

## Changelog

## 0.1.10.3

1.增加AppDelegateBackgroud
    - 在AppDelegate中didFinishLaunchingWithOptions函数中调用   
      ```
         AppDelegateBackground.setup()
      ```
    - 移除AppDelegate中关于UIBackgroundTaskIdentifier以及相关代码
    
2.增加Log日志记录管理
    - 全局调用
    ```
      Log.enabled = true
      Log.minLevel = .warning
      Log.theme = nil
      Log.enableAsset = true //开启错误Asert调试   
      
      Log.trace("Called!!!")
      Log.debug("Who is self:", self)
      Log.info(some, objects, here)
      Log.warning(one, two, three, separator: " - ")
      Log.error(error, terminator: "😱😱😱\n")
      Log.firebase("message") 往firebase 发送crash log
      
    ```
    
    - 局部调用
    ```swift
      let log = Logger()

      log.enabled = true
      log.minLevel = .warning
      log.theme = .default
      log.enableAsset = true //开启错误Asert调试

      log.trace("Called!!!")
      log.debug("Who is self:", self)
      log.info(some, objects, here)
      log.warning(one, two, three, separator: " - ")
      log.error(error, terminator: "😱😱😱\n")
      log.firebase("message") 往firebase 发送crash log
      
    ```

## 0.1.10.2

1. Collection增加属引访问
2. 更改StateBar 不正确的获取高度.

## 0.1.10

1. 更新公共库以仅支持 iOS 14 及以上版本，移除 iOS 14 以下版本的逻辑判断。
2. 统一公共库中的命名规范，并移除警告。
3. 引入 Toast-Swift，并提供对Toast的链式封装。
4. 支持 Swift Package Manager。
5. 对 ATT（App Tracking Transparency）以及需要异步执行的代码，支持 await/async。
6. UIDevice 增加对国家和设备的获取

## 使用示例

### Toast

1. 简单的 Toast：
   ```swift
   Toast.message("你好，世界！").show()
   ```

2. 自定义 Toast：
    ```swift
    Toast.message("自定义消息")
        .duration(3)
        .backgroundColor(.green)
        .title("自定义标题")
        .show()
    ```
3. 异步 Toast：
    ```swift
    Task {
        await Toast.message("异步消息").showAsync()
        print("异步消息已显示")
    }
    ```

### ATT（App Tracking Transparency）

1. 异步请求跟踪授权：
    ```swift
    Task {
        let status = await ATT.requestTrackingAsync()
        // 处理授权状态...
    }
    ```
    
### UIDevice 扩展

1. 获取国家：
    ```swift
    UIDevice.current.country
    ```
2. 获取设备名
    ```swift
    UIDevice.current.deviceName
    ```
    
