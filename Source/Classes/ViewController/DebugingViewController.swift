//
//  FloatingViewController.swift
//  TestSPM
//
//  Created by lidong on 2024/4/12.
//

import Foundation
import UIKit
import Components

class DebugingViewController : DebugingBaseViewController{
    
    var dataSource = DebugingComponents.sections
    
    var closeActionCallback: (()->Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "OOGDebugingKit"
        loadUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        leftButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        leftButton.isHidden = true
    }
    
    
    func loadUI(){
        self.navigationController?.navigationBar.addSubview(leftButton)
        leftButton.centerY = leftButton.superview!.height/2
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    lazy var leftButton: UIButton = {
        let res = UIButton(type: .close)
        res.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        res.tapAction = { [weak self] btn in
            self?.dismiss(animated: true, completion: {
                self?.closeActionCallback?()
            })
        }
        return res
    }()
    
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        // 1.自定义 Item 的FlowLayout
        let flowLayout = UICollectionViewFlowLayout()
        // 2.设置 Item 的 Size
        flowLayout.itemSize = CGSize(
            width: 60,
            height: 60
        )
        // 3.设置 Item 的排列方式
        flowLayout.scrollDirection = .vertical
        // 4.设置 Item 的四周边距
        flowLayout.sectionInset = UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 0,
            right: 16
        )
        // 5.设置同一竖中上下相邻的两个 Item 之间的间距
        flowLayout.minimumLineSpacing = 16
        // 6.设置同一行中相邻的两个 Item 之间的间距
        flowLayout.minimumInteritemSpacing = 16
        // 7.设置UICollectionView 的页头尺寸
        flowLayout.headerReferenceSize = CGSize(
            width: 0,
            height: 0
        )
        // 8.设置 UICollectionView 的页尾尺寸
        flowLayout.footerReferenceSize = CGSize(width: 0, height: 0)
        return flowLayout
    }()
    
    lazy var collectionView: UICollectionView = {
        let res = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        res.backgroundColor = .clear
        res.showsVerticalScrollIndicator = false
        // 3.设置 UICollectionView 垂直滚动是否滚到 Item 的最底部内容
        res.alwaysBounceVertical = false
        // 4.设置 UICollectionView 垂直滚动是否滚到 Item 的最右边内容
        res.alwaysBounceHorizontal = false
        res.showsHorizontalScrollIndicator = false
        // 5.设置 UICollectionView 的数据源对象
        res.dataSource = self
        // 6.设置 UICollectionView 的代理对象
        res.delegate = self
        // 10.注册 UICollectionViewCell
        res.register(cellWithClass: CollectionItemCell.self)

        return res
    }()
    
}

extension DebugingViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource[section].types.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withClass: CollectionItemCell.self,
            for: indexPath
        )
        let section = self.dataSource[indexPath.section]
        let type = section.types[indexPath.row]
        cell.display(type)
        return cell
    }
    
}

extension DebugingViewController : UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let type = self.dataSource[indexPath.section].types[indexPath.row]
        if let vc = type.viewController {
            vc.title = type.title
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

public class CollectionItemCell : UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(icon)
        
        icon.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func display(_ type:ComponentType){
        let bundle = Bundle(for: OOGDebugingKit.self)
        if let imagePath = bundle.path(forResource:"OOGDebugingKit.bundle/\(type.icon)" , ofType: nil) {
            icon.image = UIImage(contentsOfFile: imagePath)?.with(.orange)
        }
        titleLabel.text = type.title
        titleLabel.sizeToFit()
    }
    
    lazy var icon:UIImageView = {
        let res = UIImageView(frame: .zero)
        res.contentMode = .scaleAspectFill
        res.clipsToBounds = true
        return res
    }()
    
    
    lazy var titleLabel: UILabel = {
        let res = UILabel()
        res.font = UIFont.systemFont(ofSize: 11)
        res.textColor = .black
        res.text = ""
        return res
    }()
}

