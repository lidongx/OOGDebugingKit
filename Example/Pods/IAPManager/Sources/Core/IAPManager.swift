//
//  IAPManager.swift
//  OOG104
//
//  Created by maning on 2023/1/5.
//  Copyright © 2023 maning. All rights reserved.
//

import Foundation
import StoreKit
import FIREvents

#if canImport(SuperwallKit)
import SuperwallKit
#if canImport(IAPManagerSuperwall)
import IAPManagerSuperwall
#endif
#endif


public final class IAPManager {

#if DEBUG
    //开发时是否直接设置为会员，默认非会员
    public var debugCloseIap = false
#endif
    
    private static var SDKPlatform: IAPPurchaseSDK = .empty
    /// 是否已经初始化配置
    private static var isInitialized = false
    
    /// 接收到TrialStarted通知
    internal var trialInfo: SubscriptionTrial?
        
    private static var singleInstance = IAPManager()
    
    public static var shared: IAPManager {
        assert(isInitialized, "没有初始化")
        return singleInstance
    }

    ///获取通知
    public static var notificationCenter: any IAPNotification.Type {
        return SDKPlatform.sdk.iapNotificationType
    }
    
    //是否自动续订
    public var isRenew: Bool {
        return purchaseWrapper.isRenew
    }

    //是否处于订阅试用期
    public var isTrial: Bool {
        return purchaseWrapper.isTrial
    }

    //是否处于订阅有效期
    public var isActive: Bool {
        #if DEBUG
        return debugCloseIap ? true : purchaseWrapper.isActive
        #else
        return purchaseWrapper.isActive
        #endif
    }
    
    /// 用户的订阅平台ID
    public var iapSubID: String? {
        return purchaseWrapper.iapSubID
    }
    
    /// IAPManager SDK 初始化配置参数
    private(set) var iapSDKParams: any IAPConfigInit = IAPManagerConfig()

    /// 外部传入的接口，当无法弹出superwall时的预置处理（比如各项目弹出内置paywall单独使用RevenueCat接口完成支付）
    private var errorHandle: ((_ err: Error?) -> Void)?
    
    /// 外部传入的接口，当与弹出的superwall交互时的自定义事件处理
    private var customHandle: ((_ eventsName: String?) -> Void)?

#if canImport(SuperwallKit)
    /// 初始化的superwall临时缓存
    private var superWall: SuperPaywall.Interface?
    /// 初始化superwall非主动触发
    private var superWallPassiveConfig = false
#endif
    /// 监听网络状态变化后再次缓存配置
    private var hasReloaded: NetworkDetection.ListenerIdentifier?
    /// events paywallSource 参数缓存
    private var paywallSource: PaywallSource?
    /// events paywallType 参数
    private var paywallType: PaywallType?
    /// events userProperty 参数缓存
    private var userProperty: [String: Any] = [:]

    /// 老版本用户第一次配置revenue cat瞬间的订阅状态
    private var lastActiveState = false

    ///发送的事件平台
    private(set) var eventsPlatforms: Set<Platform> = []
    
    private lazy var purchaseWrapper = Self.SDKPlatform.platform
    
    private var offerMap = [String: IAPOfferOrPaywall]()
    
    private var productsMap = [String: [IAPProduct]]()
    
    private init() {

        let T = Self.notificationCenter
        NotificationCenter.add(observer: self, selector: #selector(TrialStarted), noti: T.trialStarted)
        NotificationCenter.add(observer: self, selector: #selector(sendSubscriptionRenewedEvent), noti: T.subscriptionRenewed)
        NotificationCenter.add(observer: self, selector: #selector(sendSubscriptionConvertedEvent), noti: T.subscriptionConverted)
    
    }

    /// 优先级最高的基础配置，初始化时必须优先调用
    /// - Parameters:
    ///   - sdk: 主工程指定
    ///   - block: 各自的配置信息，必须实现
    ///   - completion: 配置完成的回调
    public static func config(
        sdk: IAPPurchaseSDK,
        platforms: Set<Platform> = [.firebase],
        param: (_ iapConfig: inout IAPConfigInit) -> Void,
        completion: ((Error?) -> Void)? = nil,
        lastSubscribeState: Bool = false
    ) {
        
        SDKPlatform = sdk
        isInitialized = !sdk.isEmpty
        assert(!sdk.isEmpty, "没有指定有效的内购平台")
        
        let iap = IAPManager.shared
        iap.eventsPlatforms = platforms
        iap.lastActiveState = lastSubscribeState
        
        param(&iap.iapSDKParams)
        
        assert(iap.iapSDKParams.iapPlacements.count > 0, "iapPlacements为空")
        assert(iap.iapSDKParams.iapPublicKey.count > 0, "apiPublicKey没有配置")
        assert(iap.iapSDKParams.iapIdentify.count > 0, "Entitlement或者Access level没有配置")
#if canImport(SuperwallKit)
        assert(iap.iapSDKParams.iapPaywallPublicKey.count > 0, "superwall api key没有配置")
        SuperPaywall.configAPI(
            key: iap.iapSDKParams.iapPaywallPublicKey,
            dataCollectionEnabled: iap.iapSDKParams.iapPaywallDataCollectionEnable,
            language: iap.iapSDKParams.iapPaywallLocaleIdentifier,
            property: iap.iapSDKParams.iapPaywallProperty
        )
#if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            assert(iap.superWallPassiveConfig, "IAPManager.enablePassivePaywall没有初始化")
        }
#endif
#endif
        iap.purchaseWrapper.iapInitialize(configParams: iap.iapSDKParams) { err in
            completion?(err)
            iap.prepareCache()
        }
    }

}
#if canImport(SuperwallKit)
//MARK: - SuperWall处理
extension IAPManager {
    ///  常规方式触发弹出SuperWall
    /// - Parameters:
    ///   - viewController: 弹出Superwall的viewController
    ///   - triger: 触发弹出的条件，通常在superwall控制台配置
    ///   - paywallSource: 触发弹出的页面类型
    ///   - userProperty: 用户自定义收集传递的参数字典
    ///   - buyHandle: 点击SuperWall进行购买操作的callback
    ///   - restoreHandle: 点击SuperWall进行恢复购买操作的callback
    ///   - showHandle: 弹出Superwall后的callback，相关参数：paywall: 展示的Superwall页面
    ///   - dismissHandle: Superwall消失后的callback
    ///   - errorHandle: 弹出Superwall过程中出现的错误，相关参数：error: 错误信息
    public func popUpRegular(
        viewController: UIViewController,
        triger: String,
        paywallSource: PaywallSource,
        otherParams: [String : Any] = [:],
        ignoralCache: Bool = false,
        paywallType: PaywallType,
        adaptedJSString: String? = nil,
        userProperty: [String: Any] = [:],
        errorHandle: @escaping ((_ err: Error?) -> Void),
        customHandle: ((_ eventsName: String?) -> Void)? = nil,
        buyHandle: ((_ result: IAPPurchaseResult) -> ())? = nil,
        restoreHandle: ((_ result: IAPPurchaseResult) -> ())? = nil,
        showHandle: ((_ paywall: SuperPaywall.Interface.PaywallModel?) -> Void)? = nil,
        dismissHandle: ((String?)->())? = nil,
        didDismissHandle: ((String?)->())? = nil
    ) {

        self.errorHandle = errorHandle
        self.customHandle = customHandle

        setUpPaywall(viewController: viewController,
                     triger: triger,
                     paywallSource: paywallSource,
                     otherParams: otherParams,
                     ignoralCache: ignoralCache,
                     paywallType: paywallType,
                     userProperty: userProperty,
                     adaptedJSString: adaptedJSString)?
        .configPaywallUI()?
        .checkSubscriptionState()?
        .paywallPurchase(buyHandle: buyHandle)?
        .paywallRestore(restoreHandle: restoreHandle)?
        .show(showHandle: showHandle)?
        .dismiss(dismissHandle: dismissHandle)?
        .didDismiss(dismissHandle: didDismissHandle)?
        .error(errorHandle: errorHandle)?
        .custom()
    }

    ///  通过Events方式触发弹出SuperWall
    /// - Parameters:
    ///   - name: Events名称
    ///   - params: Events参数
    ///   - userProperty: 用户自定义收集传递的参数字典
    ///   - buyHandle: 点击SuperWall进行购买操作的callback
    ///   - restoreHandle: 点击SuperWall进行恢复购买操作的callback
    ///   - showHandle: 弹出Superwall后的callback，相关参数：paywall: 展示的Superwall页面
    ///   - dismissHandle: Superwall消失后的callback
    ///   - errorHandle: 弹出Superwall过程中出现的错误，相关参数：error: 错误信息
    public func popUpByEvent<T: FIREventSendable>(name: T,
                             params: [T.Parameter: Any],
                             userProperty: [String: Any] = [:],
                             errorHandle: @escaping ((_ err: Error?) -> Void),
                             buyHandle: ((_ result: IAPPurchaseResult) -> ())? = nil,
                             restoreHandle: ((_ result: IAPPurchaseResult) -> ())? = nil,
                             showHandle: ((_ paywall: SuperPaywall.Interface.PaywallModel?) -> Void)? = nil,
                             dismissHandle: ((String?)->())? = nil) {
        self.errorHandle = errorHandle

        setUpEventsPaywall(name: name,
                          params: params,
                          userProperty: userProperty)?
        .configPaywallUI()?
        .checkSubscriptionState()?
        .paywallPurchase(buyHandle: buyHandle)?
        .paywallRestore(restoreHandle: restoreHandle)?
        .show(showHandle: showHandle)?
        .dismiss(dismissHandle: dismissHandle)?
        .error(errorHandle: errorHandle)
    }
    /// 非主动触发的SuperWall处理
    /// - Parameters:
    ///   - buyHandler: 购买处理
    ///   - restoreHandler: 恢复处理
    ///   - isSubscribedHandler: 是否订阅（便于后台控制订阅用户不展示paywall）
    public func enablePassivePaywall(
        buyHandler: @escaping (_ result: IAPPurchaseResult) -> Void,
        restoreHandler: @escaping (_ result: IAPPurchaseResult) -> Void,
        isSubscribedHandler: @escaping () -> Bool
    ) {
        superWallPassiveConfig = true
        SuperPaywall.configPassivePaywall { product, complete in
            guard let buyProduct = product else {
                let err = IAPInternalError(.productNotAvailable)
                let result = err.result
                 complete?(.failed(err))
                buyHandler(result)
                return
            }
            
            let m_source = self.paywallSource
            let m_type = self.paywallType
            let m_designId = SuperPaywall.currentPaywallName ?? ""
            
            self.purchase(
                designId: m_designId,
                paywallSource: m_source ?? .other(name: "app_launch"),
                paywallType: m_type ?? .other(name: "standard"),
                productID: buyProduct.productIdentifier
            ) { result in
             
                DispatchQueue.main.async {
                    if result.userCancel{
                        complete?(.cancelled)
                        buyHandler(result)
                        return
                    }
                    if let resultError = result.error, resultError.localizedDescription.count > 0 {
                        complete?(.failed(resultError))
                        buyHandler(result)
                        return
                    }
                    guard result.isBuySucess || result.isActive else {
                        complete?(.failed(IAPInternalError(.productNotAvailable)))
                        buyHandler(result)
                        return
                    }
                    complete?(.succeed)
                    buyHandler(result)
                }
            }
        } restore: { complete in
            self.restore { result in
                DispatchQueue.main.async {
                    let err: Error?
                    if result.isActive {
                        err = nil
                    } else {
                        err = result.error ?? IAPInternalError(.unknownError)
                    }
                    complete?(err)
                    restoreHandler(result)
                }
            }
        } isSubscribed: {
            return isSubscribedHandler()
        } show: { paywall in
            self.sendPaywallTrigerEvent(
                designId: paywall.name,
                productIDs: paywall.products,
                paywallSource: self.paywallSource,
                paywallType: self.paywallType,
                eventsType: .paywall_viewed
            )
        } hide: { paywall, force in
            if force {
                self.sendPaywallTrigerEvent(
                    designId: paywall.name,
                    productIDs: paywall.products,
                    paywallSource: self.paywallSource,
                    paywallType: self.paywallType,
                    eventsType: .paywall_closed
                )
            }
        }
    }

    /// 追踪Superwall的事件
    /// - Parameter eventsHandler: 事件处理回调（事件名字， 事件参数）
    public func trackSuperwallEvents(eventsHandler: ((_ name: String, _ param: [String: Any]) -> Void)?) {
        SuperPaywall.trackEvents(handler: eventsHandler)
    }
    
    ///  常规方式触发弹出SuperWall
    /// - Parameters:
    ///   - viewController: 弹出Superwall的viewController
    ///   - triger: 触发弹出的条件，通常在superwall控制台配置
    ///   - paywallSource: 触发弹出的页面类型
    ///   - userProperty: 用户自定义收集传递的参数字典
    @discardableResult
    fileprivate func setUpPaywall(
        viewController: UIViewController,
        triger: String,
        paywallSource: PaywallSource,
        otherParams: [String: Any] = [:],
        ignoralCache: Bool = false,
        paywallType: PaywallType,
        userProperty: [String: Any],
        adaptedJSString: String?
    ) -> Self? {

        guard checkInitial() else { return nil }

        guard SuperPaywall.canTrigger(ignore: ignoralCache) else {
            DispatchQueue.main.async {
                self.errorHandle?(nil)
            }
            return nil
        }

        var params = otherParams
        params["paywall_source"] = paywallSource.sourceName
        superWall = SuperPaywall.triger(
            triger,
            params: params,
            in: viewController,
            userProperty: userProperty,
            force: ignoralCache
        )
        if let js = adaptedJSString {
            superWall?.add(jsVarContent: js)
        }
        self.paywallSource = paywallSource
        self.paywallType = paywallType
        self.userProperty = userProperty

        return self
    }

    ///  通过Events方式触发弹出SuperWall
    /// - Parameters:
    ///   - name: Events名称
    ///   - params: Events参数
    ///   - userProperty: 用户自定义收集传递的参数字典
    @discardableResult
    fileprivate func setUpEventsPaywall<T: FIREventSendable>(name: T,
                                                       params: [T.Parameter: Any],
                                                       userProperty: [String: Any]) -> Self? {

        guard checkInitial() else { return nil }

        guard SuperPaywall.canTrigger() else {
            DispatchQueue.main.async {
                self.errorHandle?(nil)
            }
            return nil
        }

        guard let vc = IAPManager.topViewController() else { return nil }

        var dict: [String: Any] = [:]
        params.forEach { (k, v) in
            dict[k.rawValue] = v
        }

        superWall = SuperPaywall.triger(
            name.rawValue,
            params: dict,
            in: vc,
            userProperty: userProperty
        )

        self.userProperty = userProperty

        return self
    }

    ///  弹出paywall的背景色设置
    /// - Parameters:
    ///   - bgColor: 弹出paywall的背景色
    ///   - loadingColor: 弹出paywall的loading图层背景色
    /// - Returns: IAPManager实例
    @discardableResult
    fileprivate func configPaywallUI() -> Self? {
        guard checkInitial(andSuperWall: true) else { return self }

        superWall?.loadingConfig{ [weak self] cfg in
            if let bgColor = self?.iapSDKParams.iapPaywallBGColor {
                cfg.bgColor = bgColor 
            }

            if let loadingColor = self?.iapSDKParams.iapPaywallLoadingColor {
                cfg.loadingColor = loadingColor
            }
        }
        return self
    }

    /// 检查当前的订阅状态
    /// - Returns: IAPManager实例
    @discardableResult
    fileprivate func checkSubscriptionState() -> Self? {
        guard checkInitial(andSuperWall: true) else { return self }

        superWall?.isSubscription{ [weak self] in
            guard let self = self else { return false }

            return self.isActive
        }
        return self
    }

    ///  执行购买
    /// - Parameter buyHandle: 点击paywall进行购买操作的callback
    /// - Returns: IAPManager实例
    @discardableResult
    fileprivate func paywallPurchase(buyHandle: ((_ result: IAPPurchaseResult) -> ())? = nil) -> Self? {
        guard checkInitial(andSuperWall: true) else { return self }

        superWall?.buyProduct({ paywall, product, complete in
            guard let buyProduct = product else {
                let err = IAPInternalError(.productNotAvailable)
                let result = err.result
                complete?(.failed(err))
                buyHandle?(result)
                return
            }
            
            self.purchase(
                designId: paywall?.name ?? "",
                paywallSource: self.paywallSource ?? .other(name: "emptySource"),
                paywallType: self.paywallType ?? .other(name: "emptyType"),
                productID: buyProduct.productIdentifier
            ) { result in
                
                DispatchQueue.main.async {
                    defer {
                        buyHandle?(result)
                    }
                    
                    if result.userCancel{
                        complete?(.cancelled)
                        return
                    }
                    guard result.isBuySucess || result.isActive else {
                        let err = result.error ?? IAPInternalError(.productNotAvailable)
                        complete?(.failed(err))
                        return
                    }
                    complete?(.succeed)
                }
            }
        })

        return self
    }

    ///  执行恢复购买
    /// - Parameter restoreHandle: 点击paywall进行恢复购买操作的callback
    /// - Returns: IAPManager实例
    @discardableResult
    fileprivate func paywallRestore(restoreHandle: ((_ result: IAPPurchaseResult) -> ())? = nil) -> Self? {
        guard checkInitial(andSuperWall: true) else { return self }

        superWall?.restored{ [weak self] paywall, complete in
            self?.restore { result in
                let err: Error?
                if result.isActive {
                    err = nil
                } else {
                    err = result.error ?? IAPInternalError(.unknownError)
                }
                complete?(err)
                restoreHandle?(result)
            }
        }
        return self
    }

    ///  弹出paywall后的设置
    /// - Parameter showHandle: 弹出paywall后的callback
    ///  - paywall：当前弹出的paywall
    /// - Returns: IAPManager实例
    @discardableResult
    fileprivate func show(showHandle: ((_ paywall: SuperPaywall.Interface.PaywallModel?) -> Void)? = nil) -> Self? {
        guard checkInitial(andSuperWall: true) else { return self }

        superWall?.show { [weak self] paywall in
            guard let self = self else { return }

            if let superWall = paywall {
                self.sendPaywallTrigerEvent(designId: superWall.name,
                                       productIDs: superWall.products,
                                       paywallSource: self.paywallSource,
                                            paywallType: self.paywallType,
                                       eventsType: .paywall_viewed)
            }

            showHandle?(paywall)
        }
        return self
    }

    ///  paywall消失后的设置
    /// - Parameter dismissHandle: paywall消失后的callback
    /// - Returns: IAPManager实例
    @discardableResult
    fileprivate func dismiss(dismissHandle: ((String?)->())? = nil) -> Self? {
        guard checkInitial(andSuperWall: true) else { return self }

        superWall?.hide{ [weak self] paywall, force in
            guard let self = self else { return }

            if let superWall = paywall, force {
                self.sendPaywallTrigerEvent(designId: superWall.name,
                                       productIDs: superWall.products,
                                       paywallSource: self.paywallSource,
                                            paywallType: self.paywallType,
                                       eventsType: .paywall_closed)
            }

            dismissHandle?(paywall?.nextTrigger)
            self.superWall = nil
        }
        return self
    }
    
    ///  paywall消失后的设置
    /// - Parameter dismissHandle: paywall消失后的callback
    /// - Returns: IAPManager实例
    @discardableResult
    fileprivate func didDismiss(dismissHandle: ((String?)->())? = nil) -> Self? {
        guard checkInitial(andSuperWall: true) else { return self }

        superWall?.didHide{ paywall, force in

            dismissHandle?(paywall?.nextTrigger)
        }
        return self
    }
    ///  弹出paywall过程中的错误处理
    /// - Parameter errorHandle: 弹出paywall过程中出错的callback
    ///  - err：弹出时的错误信息
    /// - Returns: IAPManager实例
    @discardableResult
    fileprivate func error(errorHandle: ((_ err: Error?) -> Void)? = nil) -> Self? {
        guard checkInitial(andSuperWall: true) else { return self }

        superWall?.error { [weak self] err in
            if let skip = err as? PaywallSkippedReason {
                switch skip {
                case .holdout(let x):
                    self?.errorHandle?(IAPSWError.holdout(x.id))
                default:
                    self?.errorHandle?(IAPSWError.other)
                }
            } else {
                self?.errorHandle?(err)
            }
        }
        return self
    }

    @discardableResult
    fileprivate func custom() -> Self? {
        guard checkInitial(andSuperWall: true) else { return self }
        superWall?.handleCustom{ [weak self] name in
            self?.customHandle?(name)
        }
        
        return self
    }
    
    fileprivate func checkInitial(andSuperWall checkSuperWall: Bool = false) -> Bool {
        guard Self.isInitialized else {
            
            DispatchQueue.main.async {
                self.errorHandle?(nil)
            }
            return false
        }

        if checkSuperWall {
            guard superWall != nil else {
                
                DispatchQueue.main.async {
                    self.errorHandle?(nil)
                }

                return false
            }
        }

        return true
    }
}
#endif
//MARK: - 购买模块 public
extension IAPManager {
    /// 执行购买
    /// - Parameters:
    ///   - designId: paywall的设计id发事件使用
    ///   - paywallSource: paywall弹出节点
    ///   - paywallType: paywall类型
    ///   - productID: 购买所需Product ID
    ///   - buyHandle: 点击paywall进行购买操作的callback
    public func purchase(designId: String,
                         paywallSource: PaywallSource,
                         paywallType: PaywallType,
                         productID: String,
                         buyHandle: IAPPurchaseBlock? = nil) {
        guard Self.isInitialized else {
            let result = IAPInternalError(.configurationError).result
            buyHandle?(result)
            return
        }

        self.sendPaywallTrigerEvent(designId: designId,
                                    productIDs: [productID],
                                    paywallSource: paywallSource,
                                    paywallType: paywallType,
                                    eventsType: .purchase_continued)
        self.purchase(productID: productID) { [weak self] result in
            buyHandle?(result)

            if result.isActive {
                guard let self = self else { return }

                self.sendPaywallTrigerEvent(designId: designId,
                                            productIDs: [productID],
                                            paywallSource: paywallSource,
                                            paywallType: paywallType,
                                            eventsType: .purchase_completed)
                if let info = self.trialInfo {
                    self.sendTrialStartedEvent(info, designId: designId, paywallSource: paywallSource, paywallType: paywallType)
                }
            }
        }
    }

    /// 执行购买
    /// - Parameters:
    ///   - designId: paywall的设计id发事件使用
    ///   - paywallSource: paywall弹出节点
    ///   - paywallType: paywall类型
    ///   - product: 购买所需product
    ///   - buyHandle: 点击paywall进行购买操作的callback
    public func purchase(designId: String,
                         paywallSource: PaywallSource,
                         paywallType: PaywallType,
                         product: IAPProduct,
                         buyHandle: IAPPurchaseBlock? = nil) {
        guard Self.isInitialized else {
            let result = IAPInternalError(.configurationError).result
            buyHandle?(result)
            return
        }

        let productID = product.productId

        self.sendPaywallTrigerEvent(designId: designId,
                                    productIDs: [productID],
                                    paywallSource: paywallSource,
                                    paywallType: paywallType,
                                    eventsType: .purchase_continued)

        purchaseWrapper.purchase(product: product) { [weak self] result in
            buyHandle?(result)
            
            if result.isBuySucess || result.isActive {
                guard let self = self else { return }

                self.sendPaywallTrigerEvent(designId: designId,
                                            productIDs: [productID],
                                            paywallSource: paywallSource,
                                            paywallType: paywallType,
                                            eventsType: .purchase_completed)
                if let info = self.trialInfo {
                    self.sendTrialStartedEvent(info, designId: designId, paywallSource: paywallSource, paywallType: paywallType)
                }
            }
        }
    }
    
    ///  执行恢复购买
    /// - Parameter handle: 点击恢复购买操作的callback
    public func restore(handle: ((_ result: IAPPurchaseResult) -> ())?) {
        guard Self.isInitialized else {
            let result = IAPInternalError(.configurationError).result
            handle?(result)
            return
        }
        
        purchaseWrapper.restore { [weak self] result in
            handle?(result)

            guard let self = self else { return }
            let sub_id = self.purchaseWrapper.iapSubID ?? ""
            if let error = result.error {
                var params = [FIREvents.IAPManager_Custom.Parameter : Any]()
                params[.subID] = sub_id
                params[.device] = self.getDevice()
                params[.space] = self.getSpace()
                params[.isSubscribe] = self.lastActiveState
                params[.error] = error.localizedDescription
                params[.code] = error.code
                FIREvents.sendCustomEvents(event: .restoreReceiptKVO, param: params)
            }
        }
    }
    
    public func getOfferingOrPaywall(placementID: String, completion: (( IAPOfferOrPaywall?) -> Void)?) {
        purchaseWrapper.getOfferingOrPaywall(placementID: placementID, completion: completion)
    }
    
    public func login(uid: String, completion: ((Bool) -> Void)?) {
        purchaseWrapper.login(uid: uid, completion: completion)
    }
    
    public func logout(completion: ((Bool) -> Void)?) {
        purchaseWrapper.logout(completion: completion)
    }
    
    public func setAttribution(_ name: IAPAttribution, value: String?) {
        purchaseWrapper.setAttribution(name, value: value)
    }
    
    public func updateProfile(_ name: IAPProfileCategory, value: String?) {
        purchaseWrapper.updateProfile(name, value: value)
    }
}

extension IAPManager {
    
    private func prepareCache() {
        let m = NetworkDetection.shared
        guard m.hasNetwork else {
            hasReloaded = m.add { [weak self] hasNetwork in
                if hasNetwork {
                    self?.reload()
                }
            }
            return
        }
        cacheAllPaywallAndProducts()
    }
    
    private func cacheAllPaywallAndProducts() {
        let placements = iapSDKParams.iapPlacements
        Task { @MainActor in
            var offerDict = [String: IAPOfferOrPaywall]()
            var productsDict = [String: [IAPProduct]]()
            for place in placements {
                guard let offer = await self.getOfferingOrPaywall(placementID: place) else {
                    continue
                }
                offerDict[place] = offer
                let arr = await offer.getProductList()
                productsDict[place] = arr
            }
            self.offerMap = offerDict
            self.productsMap = productsDict
        }
    }
    private func reload() {
        guard let l = hasReloaded else { return }
#if canImport(SuperwallKit)
        Superwall.shared.preloadAllPaywalls()
#endif
        cacheAllPaywallAndProducts()
        
        NetworkDetection.shared.remove(listener: l)
        hasReloaded = nil
    }
}

extension IAPManager: SubscriptionViewEventsProtocol {
    
    /// 根据 product id 购买
    /// - Parameters:
    ///   - productID: 外部传入的 产品ID
    ///   - buyHandle: 购买结果回调
    fileprivate func purchase(productID: String, buyHandle: IAPPurchaseBlock?) {
        
        if let product = productsMap.values.flatMap({$0}).first(where: {$0.productId == productID}) {
            purchaseWrapper.purchase(product: product, buyHandle: buyHandle)
            return
        }
        
        let placements = iapSDKParams.iapPlacements

        Task {
            var product: IAPProduct?
            for place in placements {
                guard let paywall = await self.getOfferingOrPaywall(placementID: place)  else {
                    continue
                }
                let products = await paywall.getProductList()
                if let p = products.first(where: { $0.productId ==  productID}) {
                    product = p
                    break
                }
            }
            if let p = product {
                purchaseWrapper.purchase(product: p, buyHandle: buyHandle)
            } else {
                DispatchQueue.main.async {
                    let result = IAPInternalError(.productNotAvailable).result
                    buyHandle?(result)
                }
            }
        }
    }
    
    
    /// 获取指定 placement的 offer或者paywall
    /// - Parameter placementID: 指定的placement
    /// - Returns: [offer/paywall]
    public func getOfferingOrPaywall(placementID: String) async -> IAPOfferOrPaywall? {
        return await withCheckedContinuation { continuation in
            self.getOfferingOrPaywall(placementID: placementID) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    ///购买指定产品id的异步方法
    public func purchase(
        designId: String,
        paywallSource: PaywallSource,
        paywallType: PaywallType,
        productID: String
    ) async -> IAPPurchaseResult {
        return await withCheckedContinuation { continuation in
            self.purchase(designId: designId, paywallSource: paywallSource, paywallType: paywallType, productID: productID) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    ///购买指定产品的异步方法
    public func purchase(
        designId: String,
        paywallSource: PaywallSource,
        paywallType: PaywallType,
        product: IAPProduct
    ) async -> IAPPurchaseResult {
        return await withCheckedContinuation { continuation in
            self.purchase(designId: designId, paywallSource: paywallSource, paywallType: paywallType, product: product) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    ///恢复购买的异步方法
    public func restore() async -> IAPPurchaseResult {
        return await withCheckedContinuation { continuation in
            self.restore { result in
                continuation.resume(returning: result)
            }
        }
    }
    /// 获取指定placement配置的产品列表
    /// - Parameter placementID: 指定的placement
    /// - Returns: 产品列表
    public func getProducts(placementID: String) -> [IAPProduct] {
        return productsMap[placementID] ?? []
    }
    
    /// 获取指定productID的商品
    /// - Parameter productID: 指定的商品ID
    /// - Returns: 商品
    public func getProduct(productID: String) -> IAPProduct? {
        return productsMap.values.flatMap{$0}.first { $0.productId == productID }
    }
    
    public func setAttribution(customAttribution value: String?, key: String) {
        purchaseWrapper.setAttribution(.custom(key: key), value: value)
    }
    
    public func updateProfile(customProperty value: String?, key: String) {
        purchaseWrapper.updateProfile(.custom(key: key), value: value)
    }
}

//MARK: - 弃用的方法
public extension IAPManager {
    
    @available(*, deprecated, message: "使用getOfferingOrPaywall(),然后使用paywall.getProductList()")
    func getPaywallProducts(placementId: String) async -> [IAPProduct] {
        guard let paywall = await getOfferingOrPaywall(placementID: placementId) else {
            return []
        }
        return await paywall.getProductList()
    }
    
    @available(*, deprecated, message: "使用getOfferingOrPaywall(),然后使用paywall.paywallDesigns")
    func getPaywallDesigns(placementId: String) async -> [PaywallDesigns]? {
        guard let paywall = await getOfferingOrPaywall(placementID: placementId) else {
            return nil
        }
        return paywall.paywallDesigns
    }
    
    @available(*, deprecated, message: "使用getOfferingOrPaywall(),然后使用paywall.logShow()方法")
    func logShow(placementId: String) async {
        guard let paywall = await getOfferingOrPaywall(placementID: placementId) else {
            return
        }
        paywall.logShow()
    }
}
