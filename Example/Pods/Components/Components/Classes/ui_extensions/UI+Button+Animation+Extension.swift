//
//  OOGAnimationUIButton+Extension.swift
//  TestFoo1
//
//  Created by guoqiang on 2024/1/10.
//

import UIKit

extension UIButton {
    
    public struct AnimationControlConfig {
        ///变小时间
        public var smallAnimationTime: Double = 0.1
        ///变小比例
        public var smallAnimationScale: Double = 0.95
        ///还原时间
        public var bigAnimationTime: Double = 0.2
        ///震动强度
        public var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle = .heavy
        ///能否震动
        public var canFeedback: Bool = true
    
        public init(smallAnimationTime: Double, smallAnimationScale: Double, bigAnimationTime: Double, feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle, canFeedback: Bool) {
            self.smallAnimationTime = smallAnimationTime
            self.smallAnimationScale = smallAnimationScale
            self.bigAnimationTime = bigAnimationTime
            self.feedbackStyle = feedbackStyle
            self.canFeedback = canFeedback
        }
    
        public init() {
    
        }
    
    }
    
    private struct AssociatedKeys {
        static var feedbackGenerator = "feedbackGenerator"
        static var animationConfig = "animationConfig"
        static var alreadyOutSide = "alreadyOutSide"
        static var touchComplete = "touchComplete"
    }
    

    private var feedbackGenerator: UIImpactFeedbackGenerator? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.feedbackGenerator.unsafeRawPointer) as? UIImpactFeedbackGenerator
        }
        set {
            let rawPoint = UnsafeRawPointer(bitPattern: AssociatedKeys.feedbackGenerator.hashValue)!
            objc_setAssociatedObject(self, rawPoint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var animationConfig: AnimationControlConfig? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.animationConfig.unsafeRawPointer) as? AnimationControlConfig
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.animationConfig.unsafeRawPointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var alreadyOutSide: Bool? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.alreadyOutSide.unsafeRawPointer) as? Bool
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.alreadyOutSide.unsafeRawPointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var oogTouchComplete: (()->())? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.touchComplete.unsafeRawPointer) as? ()->()
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.touchComplete.unsafeRawPointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    private func oogScaleAnimation(scale: CGFloat = 0.95, duration: Double = 0.1, completion: (() -> Void)? = nil) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        } completion: { _ in
            completion?()
        }
    }

    private func oogResetTransform(duration: Double = 0.2, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration) {
            self.transform = .identity
        } completion: { _ in
            self.isUserInteractionEnabled = true
            completion?()
        }
    }
    
    private func vibrationAnimation() {
        if animationConfig?.canFeedback == false { return }
        UISelectionFeedbackGenerator().selectionChanged()
        feedbackGenerator?.impactOccurred()
        feedbackGenerator?.prepare()
    }
    
    @objc
    private func touchDown() {
        guard let config = animationConfig else { return }
        alreadyOutSide = false
        oogScaleAnimation(scale: config.smallAnimationScale, duration: config.smallAnimationTime)
    }
    
    @objc
    private func touchUpInside() {
        guard let config = animationConfig else { return }
        if alreadyOutSide == true { return }
        oogResetTransform(duration: config.bigAnimationTime) { [weak self] in
            self?.vibrationAnimation()
            self?.oogTouchComplete?()
        }
    }
    
    @objc
    private func touchRest() {
        guard let config = animationConfig else { return }
        alreadyOutSide = true
        oogResetTransform(duration: config.bigAnimationTime)
    }
    
    
  
    public func addScaleAnimation(_ config: AnimationControlConfig = .init(), touchComplete: (()->())?) {
        
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchRest), for: .touchUpOutside)
        addTarget(self, action: #selector(touchRest), for: .touchDragExit)
        addTarget(self, action: #selector(touchRest), for: .touchCancel)
        
        self.animationConfig = config
        self.oogTouchComplete = touchComplete
        if config.canFeedback == false { return }
        self.feedbackGenerator = UIImpactFeedbackGenerator(style: config.feedbackStyle);
        self.feedbackGenerator?.prepare()
        
    }
    
}
