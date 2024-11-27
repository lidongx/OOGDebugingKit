//
//  FontHelp.swift
//  OOG301
//
//  Created by mac on 2021/7/1.
//

import Foundation
import CoreFoundation
import UIKit


public enum OOGFontType : Hashable {
    
    private static var fontMap = [OOGFontType:String]()
    
    case extraLight
    case light
    case medium
    case extraBold
    case regular
    case bold
    case black
    case thin
    case semiBold
    case semiBoldItalic
    case extraBoldItalic
    case lightItalic
    case thinItalic
    case boldItalic
    case italic
    case blackItalic
    case arbnbnumber // 自定义等宽字体
    case custom(String)
    
    var name: String {
        switch self {
        case .extraLight: return OOGFontType.fontMap[self] ?? "Poppins-ExtraLight"
        case .light: return OOGFontType.fontMap[self] ?? "Poppins-Light"
        case .medium: return OOGFontType.fontMap[self] ?? "Poppins-Medium"
        case .extraBold: return OOGFontType.fontMap[self] ?? "Poppins-ExtraBold"
        case .regular: return OOGFontType.fontMap[self] ?? "Poppins-Regular"
        case .bold: return OOGFontType.fontMap[self] ?? "Poppins-Bold"
        case .black: return  OOGFontType.fontMap[self] ?? "Poppins-Black"
        case .thin: return OOGFontType.fontMap[self] ?? "Poppins-Thin"
        case .semiBold: return OOGFontType.fontMap[self] ?? "Poppins-SemiBold"
        case .semiBoldItalic:  return OOGFontType.fontMap[self] ?? "Poppins-SemiBoldItalic"
        case .extraBoldItalic: return OOGFontType.fontMap[self] ?? "Poppins-ExtraBoldItalic"
        case .lightItalic: return OOGFontType.fontMap[self] ?? "Poppins-LightItalic"
        case .thinItalic: return OOGFontType.fontMap[self] ?? "Poppins-ThinItalic"
        case .boldItalic: return OOGFontType.fontMap[self] ?? "Poppins-BoldItalic"
        case .italic: return OOGFontType.fontMap[self] ?? "Poppins-Italic"
        case .blackItalic: return OOGFontType.fontMap[self] ?? "Poppins-BlackItalic"
        case .arbnbnumber: return OOGFontType.fontMap[self] ?? "arbnbnumber6"
        case .custom(let string): return string
        }
    }
    
    
    /// 需要配置 不然会读取默认的字体
    /// - Parameter map: 字体字典
    public static func config(_ map:[OOGFontType:String]){
        OOGFontType.fontMap = map
    }
}


public extension UIFont {
    
    /// 配置字体
    /// - Parameter map: 字体 dctionary
    static func config(_ map:[OOGFontType:String]){
        OOGFontType.config(map)
    }
    
    //尺寸需要转换
    static func oog390(_ type: OOGFontType,_ fontSize:CGFloat) -> UIFont{
        return UIFont.init(name: type.name, size: cx390(fontSize)) ?? UIFont.systemFont(ofSize: cx390(fontSize))
    }
    
    //尺寸需要转换
    static func oog(_ type: OOGFontType,_ fontSize:CGFloat) -> UIFont{
        return UIFont.init(name: type.name, size: cX(fontSize)) ?? UIFont.systemFont(ofSize: cX(fontSize))
    }
    
    //传入真实的尺寸不需转换
    static func oogR(_ type: OOGFontType,_ fontSize:CGFloat) -> UIFont{
        return UIFont.init(name: type.name, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    //尺寸需要转换
    static func oog(_ type: OOGFontType,_ ipadSize:CGFloat, _ iphoneSize:CGFloat) -> UIFont{
        return UIFont.init(name: type.name, size: cIpad(ipadSize, iphoneSize)) ?? UIFont.systemFont(ofSize: cIpad(ipadSize, iphoneSize))
    }
    
    //尺寸需要转换
    static func oog390(_ type: OOGFontType,_ ipadSize:CGFloat, _ iphoneSize:CGFloat) -> UIFont{
        return UIFont.init(name: type.name, size: cx390(ipad: ipadSize, iphone: iphoneSize)) ?? UIFont.systemFont(ofSize: cx390(ipad: ipadSize, iphone: iphoneSize))
    }

    //传入真实的尺寸不需要转换
    static func oogR(_ type: OOGFontType,_ ipadSize:CGFloat, _ iphoneSize:CGFloat) -> UIFont{
        return UIFont.init(name: type.name, size: cIpad(ipadSize, iphoneSize)) ?? UIFont.systemFont(ofSize: rIpad(ipadSize, iphoneSize))
    }
    
}

///适用于同一个项目有多个不同字体 eg.
///enum GiloryFont: OOGFontConfig {
///    case extraBold
///
///    public var name: String {
///        switch self {
///        case .extraBold:
///            return "Gilary-ExtraBold"
///        }
///    }
///}
///func useFont() {
///    let font: UIFont = .config(PoppinsFont.thin, 15)
///    let font2: UIFont = .config(GiloryFont.extraBold, 15)
///}
public protocol OOGFontConfig {
    var name: String { get }
}

public enum PoppinsFont: OOGFontConfig {
    case extraLight
    case light
    case medium
    case extraBold
    case regular
    case bold
    case black
    case thin
    case semiBold
    case semiBoldItalic
    case extraBoldItalic
    case lightItalic
    case thinItalic
    case boldItalic
    case italic
    case blackItalic
    case arbnbnumber // 自定义等宽字体
    
    public var name: String {
        switch self {
        case .extraLight: return "Poppins-ExtraLight"
        case .light: return "Poppins-Light"
        case .medium: return "Poppins-Medium"
        case .extraBold: return "Poppins-ExtraBold"
        case .regular: return "Poppins-Regular"
        case .bold: return "Poppins-Bold"
        case .black: return "Poppins-Black"
        case .thin: return "Poppins-Thin"
        case .semiBold: return "Poppins-SemiBold"
        case .semiBoldItalic:  return "Poppins-SemiBoldItalic"
        case .extraBoldItalic: return "Poppins-ExtraBoldItalic"
        case .lightItalic: return "Poppins-LightItalic"
        case .thinItalic: return "Poppins-ThinItalic"
        case .boldItalic: return "Poppins-BoldItalic"
        case .italic: return "Poppins-Italic"
        case .blackItalic: return "Poppins-BlackItalic"
        case .arbnbnumber: return "arbnbnumber6"
        }
    }
}

public extension UIFont {
    //尺寸需要转换
    static func config390(_ config: OOGFontConfig, _ fontSize: CGFloat) -> UIFont {
        return UIFont.init(name: config.name, size: cx390(fontSize)) ?? UIFont.systemFont(ofSize: cx390(fontSize))
    }
    
    //尺寸需要转换
    static func config(_ config: OOGFontConfig, _ fontSize: CGFloat) -> UIFont {
        return UIFont.init(name: config.name, size: cX(fontSize)) ?? UIFont.systemFont(ofSize: cX(fontSize))
    }
    
    //传入真实的尺寸不需转换
    static func configR(_ config: OOGFontConfig, _ fontSize: CGFloat) -> UIFont {
        return UIFont.init(name: config.name, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    //尺寸需要转换
    static func config390(_ config: OOGFontConfig, _ ipadSize:CGFloat, _ iphoneSize:CGFloat) -> UIFont {
        return UIFont.init(name: config.name, size: cx390(ipad: ipadSize, iphone: iphoneSize)) ?? UIFont.systemFont(ofSize: cx390(ipad: ipadSize, iphone: iphoneSize))
    }
    
    //尺寸需要转换
    static func config(_ config: OOGFontConfig, _ ipadSize:CGFloat, _ iphoneSize:CGFloat) -> UIFont {
        return UIFont.init(name: config.name, size: cIpad(ipadSize, iphoneSize)) ?? UIFont.systemFont(ofSize: cIpad(ipadSize, iphoneSize))
    }
    
    //传入真实的尺寸不需要转换
    static func configR(_ config: OOGFontConfig, _ ipadSize:CGFloat, _ iphoneSize:CGFloat) -> UIFont{
        return UIFont.init(name: config.name, size: cIpad(ipadSize, iphoneSize)) ?? UIFont.systemFont(ofSize: rIpad(ipadSize, iphoneSize))
    }
}


