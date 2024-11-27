//
//  UI+Toast.swift
//  Components
//
//  Created by lidong on 2024/4/8.
//

import Foundation
#if canImport(Toast_Swift)
  import Toast_Swift
#else
    import Toast
#endif

import UIKit

//说明 Toast 仅仅只是简单的调用封装，对源代码没有改变


public class Toast{
    
    var message:String?
    var title:String?
    var image:UIImage?
    var point:CGPoint?

    var duration:TimeInterval = ToastManager.shared.duration
    var position:ToastPosition = ToastManager.shared.position
    var style:ToastStyle = ToastManager.shared.style
    var completion:((Bool)->Void)? = nil
    
    var view:UIView? = UIWindow.main
    
    @discardableResult
    public func view(_ view:UIView)->Self{
        self.view = view
        return self
    }
    
    @discardableResult
    public func message(_ message:String)->Self{
        self.message = message
        return self
    }
    
    @discardableResult
    public func text(_ text:String)->Self{
       return message(text)
    }
    
    @discardableResult
    public func duration(_ duration:TimeInterval)->Self{
        self.duration = duration
        return self
    }
    
    @discardableResult
    public func point(_ point:CGPoint)->Self{
        self.point = point
        return self
    }
    
    @discardableResult
    public func position(_ position:ToastPosition)->Self{
        self.position = position
        return self
    }
    
    @discardableResult
    public func title(_ title:String)->Self{
        self.title = title
        return self
    }
    
    @discardableResult
    public func image(_ image:UIImage)->Self{
        self.image = image
        return self
    }
    
    @discardableResult
    public func style(_ style:ToastStyle)->Self{
        self.style = style
        return self
    }
    
    @discardableResult
    public func completion(_ completion:((Bool)->Void)? = nil)->Self{
        self.completion = completion
        return self
    }
    
    //这个函数必须调用
    public func show(){
        
        if self.view == nil{
            assert(false,"view can't is null")
        }
        
        if let point = self.point{
            self.view?.makeToast(message, duration: duration, point: point, title: title, image: image, style: style, completion: completion)
        }else{
            self.view?.makeToast(message, duration: duration, position: position, title: title, image: image, style: style, completion: completion)
        }
    }

    public func showAsync() async {
        DispatchQueue.main.async {
            self.show()
        }
        return await withCheckedContinuation { [weak self] continuation in
            guard let self = self else {
                continuation.resume()
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+self.duration, execute: {
                continuation.resume()
            })
        }
    }
}

extension Toast{
    
    private static func build()->Toast{
        return Toast()
    }
    
    @discardableResult
    public static func view(_ view:UIView)->Toast{
        return build().view(view)
    }
    
    @discardableResult
    public static func message(_ message:String)->Toast{
        return build().message(message)
    }
    
    @discardableResult
    public static func duration(_ duration:TimeInterval)->Toast{
        return build().duration(duration)
    }
    
    @discardableResult
    public static func point(_ point:CGPoint)->Toast{
        return build().point(point)
    }
    
    @discardableResult
    public static func position(_ position:ToastPosition)->Toast{
        return build().position(position)
    }
    
    public static func title(_ title:String)->Toast{
        return build().title(title)
    }
    
    public static func image(_ image:UIImage)->Toast{
        return build().image(image)
    }
    
    public static func style(_ style:ToastStyle)->Toast{
        return build().style(style)
    }
    
    public static func completion(_ completion:((Bool)->Void)? = nil)->Toast{
        return build().completion(completion)
    }
    
}

extension Toast{
    
    public func backgroundColor(_ backgroundColor:UIColor)->Self{
        self.style.backgroundColor = backgroundColor
        return self
    }
    
    public func titleColor(_ titleColor: UIColor)->Self{
        self.style.titleColor = titleColor
        return self
    }
    
    public func messageColor(_ messageColor: UIColor)->Self{
        self.style.messageColor = messageColor
        return self
    }
    
    public func maxWidthPercentage(_ maxWidthPercentage: CGFloat)->Self{
        self.style.maxWidthPercentage = maxWidthPercentage
        return self
    }
    
    public func maxHeightPercentage(_ maxHeightPercentage: CGFloat)->Self{
        self.style.maxHeightPercentage = maxHeightPercentage
        return self
    }
   
    public func horizontalPadding(_ horizontalPadding:CGFloat)->Self{
        self.style.horizontalPadding = horizontalPadding
        return self
    }

 
    public func verticalPadding(_ verticalPadding:CGFloat)->Self{
        self.style.verticalPadding = verticalPadding
        return self
    }
   
    public func cornerRadius(_ cornerRadius:CGFloat)->Self{
        self.style.cornerRadius = cornerRadius
        return self
    }

    public func titleFont(_ titleFont:UIFont)->Self{
        self.style.titleFont = titleFont
        return self
    }
    
    public func messageFont(_ messageFont:UIFont)->Self{
        self.style.messageFont = messageFont
        return self
    }

    public func titleAlignment(_ titleAlignment:NSTextAlignment)->Self{
        self.style.titleAlignment = titleAlignment
        return self
    }
    
    public func messageAlignment(_ messageAlignment: NSTextAlignment)->Self{
        self.style.messageAlignment = messageAlignment
        return self
    }
    
    public func titleNumberOfLines(_ titleNumberOfLines:Int)->Self{
        self.style.titleNumberOfLines = titleNumberOfLines
        return self
    }
   
    
    public func messageNumberOfLines(_ messageNumberOfLines:Int)->Self{
        self.style.messageNumberOfLines = messageNumberOfLines
        return self
    }
    
    
    public func displayShadow(_ displayShadow:Bool)->Self{
        self.style.displayShadow = displayShadow
        return self
    }
    
    
    public func displayShadow(_ shadowColor:UIColor)->Self{
        self.style.shadowColor = shadowColor
        return self
    }
    
    
    public func shadowOpacity(_ shadowOpacity:Float)->Self{
        self.style.shadowOpacity = shadowOpacity
        return self
    }
    
    
    public func shadowRadius(_ shadowRadius:CGFloat)->Self{
        self.style.shadowRadius = shadowRadius
        return self
    }
    
    
    public func shadowOffset(_ shadowOffset:CGSize)->Self{
        self.style.shadowOffset = shadowOffset
        return self
    }
    
    
    public func imageSize(_ imageSize:CGSize)->Self{
        self.style.imageSize = imageSize
        return self
    }
    
    public func activitySize(_ activitySize:CGSize)->Self{
        self.style.activitySize = activitySize
        return self
    }
    
    public func fadeDuration(_ fadeDuration:TimeInterval)->Self{
        self.style.fadeDuration = fadeDuration
        return self
    }
    
    public func activityIndicatorColor(_ activityIndicatorColor:UIColor)->Self{
        self.style.activityIndicatorColor = activityIndicatorColor
        return self
    }
    
    public func activityBackgroundColor(_ activityBackgroundColor:UIColor)->Self{
        self.style.activityBackgroundColor = activityBackgroundColor
        return self
    }
    
}

