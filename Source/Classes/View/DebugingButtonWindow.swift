//
//  DebugingButtonWindow.swift
//  TestSPM
//
//  Created by lidong on 2024/4/17.
//

import Foundation
import UIKit
import SnapKit
import Components


class DebugingButtonWindow: DebugingMovingWindow {

    private let offset = PadddingOffset(
        top: SafeArea.top+30,
        bottom: SafeArea.bottom+30,
        left: 30,
        right: 30
    )
    
    private let buttonHeight = 40
    
    private var beginPoint: CGPoint = .zero
    private var prevPoint: CGPoint = .zero
    
    var isShowOtherButton:Bool = false
    var onActionAction:((DebugingButtonWindow)->Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(-5)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalTo(110)
        }
        
        adjustPosition()
    }
    
    lazy var icon: UIImageView = {
        let res = UIImageView(frame: CGRect(x: 0, y: 100, width: 60, height: 60))
    
        let bundle = Bundle(for: OOGDebugingKit.self)
        if let imagePath = bundle.path(forResource: "OOGDebugingKit.bundle/kit.png", ofType: nil) {
            res.image = UIImage(contentsOfFile: imagePath)
        }
        return res
    }()
    
    lazy var button: UIButton = {
        let res = UIButton(frame: .zero, target: self, action: #selector(buttonAction))
        res.transform = CGAffineTransform(rotationAngle: CGFloat.pi  )
        res.setImage(UIImage(named: "arrow.png"), for: .normal)
        return res
    }()
    
    lazy var vStackView: UIStackView = {
        let res = UIStackView(frame: .zero)
        res.axis = .vertical //垂直方向布局
        res.alignment = .center
        res.spacing = 4
        //res.distribution = .fillEqually
        return res
    }()
    
    @objc func buttonAction(){
        isShowOtherButton = !isShowOtherButton
        vStackView.isHidden = !isShowOtherButton
        if isShowOtherButton {
            for item in DebugingOtherButtonConfigs.items {
                vStackView.addArrangedSubview(item.button)
                item.button.tapAction = { btn in
                    item.callback(btn)
                }
                item.button.snp.makeConstraints { make in
                    make.height.equalTo(buttonHeight)
                }
            }
            vStackView.snp.remakeConstraints { make in
                make.top.equalTo(button.snp.bottom)
                make.centerX.equalToSuperview()
                make.height.equalTo(DebugingOtherButtonConfigs.items.count*buttonHeight)
            }
            
            UIWindow.debugingButtonWindow.height = CGFloat(
                80+DebugingOtherButtonConfigs.items.count*buttonHeight
            )
            
        } else {
            for item in DebugingOtherButtonConfigs.items {
                vStackView.removeArrangedSubview(item.button)
            }
            vStackView.snp.remakeConstraints { make in
                make.top.equalTo(button.snp.bottom)
                make.centerX.equalToSuperview()
                make.height.equalTo(0)
            }
            
            UIWindow.debugingButtonWindow.height = 80
        }
    }
    
    
   
    override func handleTouchesEnd(distance: CGFloat) {
        super.handleTouchesEnd(distance: distance)
        //移动距离小判定为点击
        if distance < 5 {
            onActionAction?(self)
        }else{
            adjustPosition()
        }
    }


    /// 修正位置 动画吸附在屏幕两侧
    func adjustPosition() {
        let screenWidth = fullScreenWidth()
        let screenHeight = fullScreenHeight()
        let rect = CGRect(
            x: offset.left,
            y: offset.top,
            width: screenWidth-offset.left-offset.right,
            height: screenHeight-offset.top-offset.bottom
        )
        if !rect.contains(self.center) {
            let targetPoint = movePointToRectEdge(self.center, within: rect)
            UIView.animate(withDuration: 0.25) {
                self.center = targetPoint
            }
        }
    }
    
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
