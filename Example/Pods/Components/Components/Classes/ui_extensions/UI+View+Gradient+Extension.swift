//
//  UIView+Gradient.swift
//
//  Created by chaichai on 2023/4/27.
//

import Foundation
import UIKit
public extension UIView {
    
    fileprivate class AutoGradView: UIView {

        let fromColor: UIColor
        let toColor: UIColor
        let startPoint: CGPoint
        let endPoint: CGPoint
        let locations: [NSNumber]
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        init(from: UIColor, to: UIColor, start: CGPoint, end: CGPoint, values: [NSNumber]) {
            fromColor = from
            toColor = to
            startPoint = start
            endPoint = end
            locations = values
            super.init(frame: .zero)
            layer.addSublayer(lay)
            isUserInteractionEnabled = false
        }
        
        lazy var lay: CAGradientLayer = {
            let layer1 = CAGradientLayer()
            layer1.colors = [fromColor.cgColor, toColor.cgColor]
            layer1.locations = [0, 1]
            layer1.startPoint = startPoint
            layer1.endPoint = endPoint
            return layer1
        }()
        
        override func layoutSubviews() {
            super.layoutSubviews()
            lay.frame = bounds
        }
    }
    
    /// 添加渐变背景色
    /// - Parameters:
    ///   - from:       开始的渐变色
    ///   - to:         结束的渐变色
    ///   - start:      渐变色开始位置
    ///   - end:        渐变色结束位置
    ///   - locations:  渐变色变化位置
    /// - Returns: void
    func makeGradient(from: UIColor, to: UIColor, start: CGPoint, end: CGPoint, locations: [NSNumber] = [0, 1]) {
        if let v = subviews.first(where: { $0 is AutoGradView }) as? AutoGradView {
            v.lay.colors = [from.cgColor, to.cgColor]
            v.lay.locations = locations
            v.lay.startPoint = start
            v.lay.endPoint = end
            return
        }
        let s = AutoGradView(from: from, to: to, start: start, end: end, values: locations)
        s.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(s, at: 0)
        s.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        s.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        s.topAnchor.constraint(equalTo: topAnchor).isActive = true
        s.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
