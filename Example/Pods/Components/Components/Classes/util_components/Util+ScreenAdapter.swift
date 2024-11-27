//
//  ScreenAdapter.swift
//  OOG104
//
//  Created by lidong on 2021/6/25.
//  Copyright © 2021 maning. All rights reserved.
//

import UIKit


public func appWindow() ->UIWindow{
    return UIApplication.shared.windows[0]
}

public func isIphoneX() -> Bool {
    var isiPhoneX: Bool = false
    if UIDevice.current.userInterfaceIdiom == .phone {
        let height = UIScreen.main.nativeBounds.size.height
        let width = UIScreen.main.nativeBounds.size.width
        var ratio: CGFloat = 0
        if height > width {
            ratio = height / width
        } else {
            ratio = width / height
        }
        if ratio >= 2.1, ratio < 2.3 {
            isiPhoneX = true
        }
    }
    return isiPhoneX
}

public func isPad() -> Bool {
    return (UIDevice.current.userInterfaceIdiom == .pad) ? true : false
}

public func isThreeCX(_ ipad: CGFloat, _ iphoneX: CGFloat, _ other: CGFloat) -> CGFloat {
    isPad() ? cX(ipad) : isIphoneX() ? cX(iphoneX) : cX(other)
}


public func fullScreenBounds() -> CGRect {
    //return UIScreen.main.bounds
    //解决屏幕旋转问题
    return CGRect(x: 0, y: 0, width: min(UIScreen.main.bounds.width,UIScreen.main.bounds.height), height: max(UIScreen.main.bounds.width,UIScreen.main.bounds.height))
}

public func fullScreenWidth() -> CGFloat {
    return fullScreenBounds().size.width
}

public func fullScreenHeight() -> CGFloat {
    return fullScreenBounds().size.height
}

public func getWidth(view: UIView) -> CGFloat {
    return view.frame.size.width
}

public func getHeight(view: UIView) -> CGFloat {
    return view.frame.size.height
}

public func setWidth(view: UIView, width: CGFloat) {
    let frame = view.frame
    view.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: frame.size.height)
}

public func setHeight(view: UIView, height: CGFloat) {
    let frame = view.frame
    view.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
}

public func convertWidth(_ x: CGFloat) -> CGFloat {
    return (x / (isPad() ? 768.0 : 375.0)) * fullScreenWidth()
}

public func convertHeight(_ y: CGFloat) -> CGFloat {
     return (y / (isPad() ? 1024.0 : 667.0)) * fullScreenHeight()
}

public func convertViewWidth(view: UIView, width: CGFloat) -> CGFloat {
    return width * getWidth(view: view) / (isPad() ? 768.0 : 375.0)
}

public func convertFont(fontsize: CGFloat) -> CGFloat {
    return fontsize * fullScreenWidth() / (isPad() ? 768.0 : 375.0)
}

public func real<T>(_ value:T)->CGFloat{
    if value is Int{
        let newValue = value as! Int
        return CGFloat(newValue)
    }
    if value is CGFloat{
        let newValue = value as! CGFloat
        return newValue
    }
    if value is Float{
        let newValue = value as! Float
        return CGFloat(newValue)
    }
    if value is Double{
        let newValue = value as! Double
        return CGFloat(newValue)
    }
    assert(false)
    return 0.0
}

@available(iOS, introduced: 1.0, deprecated: 100.0, message: "390的适配方案请使用cx390")
public func cX<T>(_ value:T)->CGFloat{
    if value is Int{
        let newValue = value as! Int
        return convertWidth(CGFloat(newValue))
    }
    if value is CGFloat{
        let newValue = value as! CGFloat
        return convertWidth(newValue)
    }
    if value is Float{
        let newValue = value as! Float
        return convertWidth(CGFloat(newValue))
    }
    if value is Double{
        let newValue = value as! Double
        return convertWidth(CGFloat(newValue))
    }
    assert(false)
    return 0.0
}

public func cY<T>(_ value:T) -> CGFloat{
    if value is Int{
        let newValue = value as! Int
        return convertHeight(CGFloat(newValue))
    }
    if value is CGFloat{
        let newValue = value as! CGFloat
        return convertHeight(newValue)
    }
    if value is Float{
        let newValue = value as! Float
        return convertHeight(CGFloat(newValue))
    }
    if value is Double{
        let newValue = value as! Double
        return convertHeight(CGFloat(newValue))
    }
    assert(false)
    return 0.0
}

//iphoneX 转换为 iphone7的适配方案
//也即IphoneX的适配方案
public func cY2<T>(_ value:T) -> CGFloat{
    if value is Int{
        let newValue = value as! Int
        return cY(CGFloat(newValue) * 667.0/812.0)
    }
    if value is CGFloat{
        let newValue = value as! CGFloat
        return cY(CGFloat(newValue) * 667.0/812.0)
    }
    if value is Float{
        let newValue = value as! Float
        return cY(CGFloat(newValue) * 667.0/812.0)
    }
    if value is Double{
        let newValue = value as! Double
        return cY(CGFloat(newValue) * 667.0/812.0)
    }
    assert(false)
    return 0.0
}

/// **屏幕尺寸为390的屏幕适配方案 将传入的参数进行缩放**
/// - Parameter value: 数字类型的参数
/// - Returns: 适配缩放的结果
public func cx390<T: BinaryFloatingPoint>(_ value: T) -> CGFloat {
    let scaleFactor = isPad() ? 768.0 : 390.0
    let res = CGFloat(value) / scaleFactor * fullScreenWidth()
    return res
}
/// **屏幕尺寸为390的屏幕适配方案 将传入的参数进行缩放**
/// - Parameter value: 整型数字类型的参数
/// - Returns: 适配缩放的结果
public func cx390<T: BinaryInteger>(_ value:T) -> CGFloat {
    let temp = CGFloat(value)
    return cx390(temp)
}

public func cx390<T: BinaryFloatingPoint,M:BinaryFloatingPoint>(ipad:T,iphone:M) -> CGFloat {
    return isPad() ? cx390(ipad) : cx390(iphone)
}

public func cx390<T: BinaryFloatingPoint,M:BinaryInteger>(ipad:T,iphone:M) -> CGFloat {
    return isPad() ? cx390(ipad) : cx390(iphone)
}

public func cx390<T: BinaryInteger,M:BinaryFloatingPoint>(ipad:T,iphone:M) -> CGFloat {
    return isPad() ? cx390(ipad) : cx390(iphone)
}
/// **屏幕尺寸为390的屏幕适配方案 将传入的参数进行缩放**
/// - Parameters:
///   - ipad: ipad尺寸的参数值
///   - iphone: iPhone尺寸的参数值
/// - Returns: 适配缩放的结果
public func cx390<T: BinaryInteger>(ipad:T, iphone:T) -> CGFloat {
    return isPad() ? cx390(ipad) : cx390(iphone)
}


public func cx390<T: BinaryFloatingPoint>(ipad:T,iphone:T,iphone8:T) -> CGFloat {
    if isPad(){
        return cx390(ipad)
    }
    if isIphoneX(){
        return cx390(iphone)
    }
    return cx390(iphone8)
}

public func cx390<T: BinaryInteger,M:BinaryFloatingPoint,N:BinaryFloatingPoint>(ipad:T,iphone:M,iphone8:N) -> CGFloat {
    if isPad(){
        return cx390(ipad)
    }
    if isIphoneX(){
        return cx390(iphone)
    }
    return cx390(iphone8)
}

public func cx390<T: BinaryFloatingPoint,M:BinaryInteger,N:BinaryFloatingPoint>(ipad:T,iphone:M,iphone8:N) -> CGFloat {
    if isPad(){
        return cx390(ipad)
    }
    if isIphoneX(){
        return cx390(iphone)
    }
    return cx390(iphone8)
}

public func cx390<T: BinaryFloatingPoint,M:BinaryFloatingPoint,N:BinaryInteger>(ipad:T,iphone:M,iphone8:N) -> CGFloat {
    if isPad(){
        return cx390(ipad)
    }
    if isIphoneX(){
        return cx390(iphone)
    }
    return cx390(iphone8)
}

public func cx390<T: BinaryInteger,M:BinaryInteger,N:BinaryFloatingPoint>(ipad:T,iphone:M,iphone8:N) -> CGFloat {
    if isPad(){
        return cx390(ipad)
    }
    if isIphoneX(){
        return cx390(iphone)
    }
    return cx390(iphone8)
}

public func cx390<T: BinaryFloatingPoint,M:BinaryInteger,N:BinaryInteger>(ipad:T,iphone:M,iphone8:N) -> CGFloat {
    if isPad(){
        return cx390(ipad)
    }
    if isIphoneX(){
        return cx390(iphone)
    }
    return cx390(iphone8)
}

public func cx390<T: BinaryInteger,M:BinaryFloatingPoint,N:BinaryInteger>(ipad:T,iphone:M,iphone8:N) -> CGFloat {
    if isPad(){
        return cx390(ipad)
    }
    if isIphoneX(){
        return cx390(iphone)
    }
    return cx390(iphone8)
}

public func cx390<T: BinaryInteger>(ipad:T,iphone:T,iphone8:T) -> CGFloat {
    if isPad(){
        return cx390(ipad)
    }
    if isIphoneX(){
        return cx390(iphone)
    }
    return cx390(iphone8)
}
