# OOGDebugingKit

OOGDebugingKit是替换掉UI界面上debug,crash,events等等一些按钮。

## 引用

1. 通过Cocospod引用，在Podfile中添加Components
    ```
    pod 'Components','~> 0.1.10.3'
    ```
    
2. 通过Swift Package Manager在Package.swift添加依赖
    ```
    dependencies: [
        .package(url: "https://github.com/lidongx/OOGDebugingKit.git", .upToNextMajor(from: "1.0.0"))
    ]
    ```

## 使用

1. 增加其它的自定义按钮
   ```
    OOGDebugingKit.setup(onlyDebug: true, otherButtonsConfig: [
        .init(buttonText: "HILKLMNOPQ", callback: { btn in
            Toast.message("Test1").show()
         }),
         .init(buttonText: "Test2", callback: { btn in
              Toast.message("Test2").show()
         }),
    ])
   ```

3. 项目需要配置各种ID
     ```
    OOGDebugingKit.config.appID = "1241414124"
    OOGDebugingKit.config.mixpanelToken
    OOGDebugingKit.config.mixpanelDeviceID
    OOGDebugingKit.config.statsigApiKey
    OOGDebugingKit.config.adaptyKey
    OOGDebugingKit.config.adaptyLevel
    OOGDebugingKit.config.supperWallKey
    OOGDebugingKit.config.oneSignalToken
    OOGDebugingKit.config.singularKey
    OOGDebugingKit.config.singularSecretKey
     ```
    
4. 订阅状态和Events以及其它的一些状态是自动获取的

