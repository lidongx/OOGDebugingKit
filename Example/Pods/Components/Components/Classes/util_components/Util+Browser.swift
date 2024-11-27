//
//  BrowserHelper.swift
//  ModuleProject
//
//  Created by guoqiang on 2021/11/17.
//

import Foundation
import UIKit

public enum WebURLType: String {
    case termsOfUse = "https://www.workoutinc.net/terms-of-use"
    case privacy = "https://www.workoutinc.net/privacy-policy"
}

public typealias Browser = Explorer

public struct Explorer {
    /// 用浏览器的方式打开网址
    /// - Parameter urlString: 网址
    public static func open(_ urlString:String = WebURLType.termsOfUse.rawValue) {
        if let url = URL(string: urlString) ,UIApplication.shared.canOpenURL(url){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
