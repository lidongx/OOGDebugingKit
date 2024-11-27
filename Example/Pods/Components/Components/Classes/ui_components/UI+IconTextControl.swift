//
//  IconTextControl.swift
//  DemoForTest
//
//  Created by lidong on 2023/9/8.
//


import UIKit
import SnapKit

/*  使用方法 测试代码
 class ViewController: UIViewController{
     override func viewDidLoad() {
         super.viewDidLoad()
         iconTextView.icon(UIImage(named: "clock"))
             .content("dfdsfsaafs")
             .iconPosition(.top)
             .edgeType(.center)
             .labelWidth(20)
             .edgeType(.edge(UIEdgeInsets(top: 100, left: 20, bottom: 20, right: 10)))
 
         iconTextView.backgroundColor = .red
         self.view.addSubview(iconTextView)
         iconTextView.snp.makeConstraints { make in
             make.center.equalToSuperview()
         }
         iconTextView.addTarget(self, action: #selector(test), for: .touchUpInside)
     }
     @objc func test(){
         print("test")
     }
     lazy var iconTextView: IconTextControl = {
         let res = IconTextControl(frame: .zero, image: UIImage(named: "clock"), content: "ssdsadadada")
         return res
     }()
 }
*/
 
/// 图片和文本组合而成的控件
public class IconTextControl: UIControl {
    
    
    /// 设置约束方式
    public var edgeType:EdgeType = .edge(.zero){
        didSet{
            refreshConstraint()
        }
    }
    
    
    /// 图片的位置
    public var iconPosition: IconPosition = .left {
        didSet {
            refreshConstraint()
        }
    }
    
    
    /// 图片与文本之间的间距
    public var spacing: CGFloat = 10 {
        didSet {
            refreshConstraint()
        }
    }
    
    
    /// 设置图片
    public var icon: UIImage? = nil {
        didSet {
            iconIV.image = icon
            refreshConstraint()
        }
    }
    
    
    /// 文本内容
    public var content: String = "" {
        didSet {
            contentLabel.text = content
        }
    }
    
    ///  设置label的宽度
    public var labelWidth:CGFloat = 0{
        didSet{
            if labelWidth == 0 {
                contentLabel.numberOfLines = 1
            }else{
                contentLabel.numberOfLines = 0
            }
            contentLabel.numberOfLines = 0
            refreshConstraint()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    init(frame:CGRect,image:UIImage?,content:String){
        super.init(frame: frame)
        loadUI()
        update(image: image, content: content)
    }
    
    
    func update(image:UIImage?,content:String){
        self.icon = image
        self.content = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    public lazy var contentView: UIView = {
        let res = UIView(frame: .zero)
        return res
    }()
    
    public lazy var iconIV: UIImageView = {
        let res = UIImageView(frame: .zero)
        return res
    }()
    
    public lazy var contentLabel: UILabel = {
        let res = UILabel()
        res.text = ""
        return res
    }()

}


public extension IconTextControl{
    fileprivate func loadUI(){
        self.addSubview(contentView)
        contentView.addSubview(iconIV)
        contentView.addSubview(contentLabel)
    }
}

public extension IconTextControl{
    
    @discardableResult
    func content(_ content:String)->Self{
        self.content = content
        return self
    }
    
    @discardableResult
    func icon(_ image:UIImage?)->Self{
        self.icon = image
        return self
    }
    
    @discardableResult
    func iconPosition(_ iconPosition:IconPosition)->Self{
        self.iconPosition = iconPosition
        return self
    }
    
    @discardableResult
    func spacing(_ spacing:CGFloat)->Self{
        self.spacing = spacing
        return self
    }
    
    @discardableResult
    func labelWidth(_ width:CGFloat)->Self{
        self.labelWidth = width
        return self
    }
    
    @discardableResult
    func edgeType(_ type:EdgeType)->Self{
        self.edgeType = type
        return self
    }
}


public extension IconTextControl{
    fileprivate func refreshConstraint() {
        switch self.edgeType{
        case .edge(let edge):
            contentView.snp.remakeConstraints { make in
                make.edges.equalTo(edge)
            }
        case .center:
            contentView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        
        let iconWidth: CGFloat = icon?.size.width ?? 0
        let iconHeight: CGFloat = icon?.size.height ?? 0
        var realSpace: CGFloat = 0
        if iconWidth > 0 && iconHeight > 0 {
            realSpace = spacing
        }
        switch iconPosition {
        case .left:
            iconIV.snp.remakeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.equalTo(iconWidth)
                make.height.equalTo(iconHeight)
                make.height.lessThanOrEqualToSuperview()
            }
            contentLabel.snp.remakeConstraints { make in
                make.leading.equalTo(iconIV.snp.trailing).offset(realSpace)
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.lessThanOrEqualToSuperview()
                if labelWidth > 0{
                    make.width.equalTo(labelWidth)
                }
            }
        case .right:
            iconIV.snp.remakeConstraints { make in
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.equalTo(iconWidth)
                make.height.equalTo(iconHeight)
                make.height.lessThanOrEqualToSuperview()
            }
            contentLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(iconIV.snp.leading).offset(-realSpace)
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.lessThanOrEqualToSuperview()
                if labelWidth > 0{
                    make.width.equalTo(labelWidth)
                }
            }
        case .top:
            iconIV.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalTo(iconWidth)
                make.height.equalTo(iconHeight)
                make.width.lessThanOrEqualToSuperview()
            }
            contentLabel.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(iconIV.snp.bottom).offset(realSpace)
                make.bottom.equalToSuperview()
                make.width.lessThanOrEqualToSuperview()
                if labelWidth > 0{
                    make.width.equalTo(labelWidth)
                }
            }
        case .bottom:
            iconIV.snp.remakeConstraints { make in
                make.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
                make.width.equalTo(iconWidth)
                make.height.equalTo(iconHeight)
                make.width.lessThanOrEqualToSuperview()
            }
            contentLabel.snp.remakeConstraints { make in
                make.bottom.equalTo(iconIV.snp.top).offset(-realSpace)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.width.lessThanOrEqualToSuperview()
                if labelWidth > 0{
                    make.width.equalTo(labelWidth)
                }
            }
        }
    }
}


public extension IconTextControl{
    //图片的位置
     enum IconPosition {
        case left
        case right
        case top
        case bottom
    }
    
    //约束方式
    enum EdgeType : Equatable{
        //四边约束
        case edge(_ edge:UIEdgeInsets)
        //居中约束
        case center
    }
}


