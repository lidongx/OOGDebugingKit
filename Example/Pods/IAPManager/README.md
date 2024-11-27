# IAPManager

[![CI Status](https://img.shields.io/travis/maningx/IAPManager.svg?style=flat)](https://travis-ci.org/maningx/IAPManager)
[![Version](https://img.shields.io/cocoapods/v/IAPManager.svg?style=flat)](https://cocoapods.org/pods/IAPManager)
[![License](https://img.shields.io/cocoapods/l/IAPManager.svg?style=flat)](https://cocoapods.org/pods/IAPManager)
[![Platform](https://img.shields.io/cocoapods/p/IAPManager.svg?style=flat)](https://cocoapods.org/pods/IAPManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

IAPManager is available through CocoaPods and SPM

#### Cocoapods

```
pod 'IAPManager', '~> 11.4.0', :subspecs => ["Superwall", "RC", "Adpt"]
```

#### Swift Package Manager

```
https://github.com/retro-labs/iOS-IAPManager.git
```
## Integration

### 1. 初始化

```swift
//sdk 各自工程使用的内购平台[rc, adapty]
IAPManager.config(sdk: .rc) { iapConfig in
	//各个工程里边用到的placement, 例如["onboarding", "standard", "banner"]
    iapConfig.iapPlacements = []

    //各个工程里边使用的内购平台的 apiKey
    iapConfig.iapPublicKey = ""

	//各个工程里边使用的内购平台的后台配置.
	//如果使用Adapty,就是控制台配置的Access level
	//如果使用RC,就是控制台配置的Entitlement
    iapConfig.iapIdentify = ""
    //通上边一样的配置，但是是针对Web端的配置
    iapConfig.iapWebIdentify = nil
    
    //如果使用的Superwall就需要下边的配置
    /***********************************************/        
    //工程里边使用到的Superwall的publickKey
    iapConfig.iapPaywallPublicKey = ""
    //是否启用Superwall的数据收集功能，开发阶段关闭，发布阶段打开
	#if DEBUG
    iapConfig.iapPaywallDataCollectionEnable = false
    #else
    iapConfig.iapPaywallDataCollectionEnable = true
    #endif
    //指定Superwall的语言环境，可选的，可以不用设置
    //iapConfig.iapPaywallLocaleIdentifier = nil
    //在Superwall中点击购买,处理交易过程防止误触添加的遮罩蒙层颜色,默认黑色60%透明度
    //iapConfig.iapPaywallBGColor
    //在Superwall中点击购买,处理交易过程的loading加载的风火轮颜色,默认白色
    //iapConfig.iapPaywallLoadingColor
    /***********************************************/
}
```

### 2. 获取Offer或者Paywall。只支持[Callback/异步]，不支持同步获取

```swift
 IAPManager.shared.getOfferingOrPaywall(placementID: "placementid")
```

#### 1. 获取某个Offer/Paywall上边的Product列表,只支持异步
```swift
paywall.getProductList()
```

#### 2. 同时对外提供了同步方法。如果有缓存信息会返回Product数组，如果没有缓存会返回空数组，这时就需要使用上边的异步获取Offer或者Paywall,然后再获取Product列表。所以使用同步方法的时候要注意为空的处理
```swift
IAPManager.shared.getProducts(placementID: "placementid")
```

#### 3. Adapty平台独有的paywall功能
```swift
paywall.logShow()
```

### 3. 购买方法,支持 IAPProduct 和 productID两种。

```swift
IAPManager.shared.purchase()
```
### 4. 恢复购买的方法。

```swift
IAPManager.shared.restore()
```

### 5. 归因属性Attribution的设置

```swift
IAPManager.shared.setAttribution()
```

### 6. 第三方SDK集成，主要针对Adapty平台

```swift
IAPManager.shared.updateProfile()
```
### 7. 获取用户的订阅ID

```swift
IAPManager.shared.iapSubID
```
### 8. 订阅通知，外部想要监听的iap通知。可以使用下边的方法，不要直接使用字符串，防止库里边修改导致外部不能接收到通知

```swift
IAPManager.notificationCenter.addObserver()
```

## Author

chaichai9323, chailintao@laien.io

## License

IAPManager is available under the MIT license. See the LICENSE file for more info.
