//
//  DebugingEventsViewController.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/22.
//

import Foundation
import UIKit
import Components
import Combine
import FIREvents
class DebugingEventsViewController : DebugingBaseViewController {
    
    @Published
    var dataSource:[DebugingEvent] = []
    var disposeBag = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAction))
        self.navigationItem.rightBarButtonItem = deleteButton
        
        self.view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(4)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        segmentControl.selectedSegmentIndex = 0
        self.dataSource = DebugingEvents.mixpanelEvents.reversed()
        $dataSource.receive(on: DispatchQueue.main).sink { value in
            self.collectionView.reloadData()
        }.store(in: &disposeBag)
    }
    
    
    @objc func deleteAction() {
        if segmentControl.selectedSegmentIndex == 0 {
            DebugingEvents.mixpanelEvents.removeAll()
            
        } else if segmentControl.selectedSegmentIndex == 1 {
            DebugingEvents.firebaseEvents.removeAll()
        }
        self.dataSource.removeAll()
    }
    
    lazy var segmentControl: UISegmentedControl = {
        let res = UISegmentedControl(items: ["Firebase","Mixpanel"])
        res.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
        return res
    }()
    
    @objc func segmentControlValueChanged() {
        if segmentControl.selectedSegmentIndex == 0 {
            self.dataSource = DebugingEvents.mixpanelEvents.reversed()
            FIREvents.clearLogs(platform: .mixPanel)
        } else if segmentControl.selectedSegmentIndex == 1 {
            self.dataSource = DebugingEvents.firebaseEvents.reversed()
            FIREvents.clearLogs(platform: .firebase)
        }
    }
    
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize // 自动调整 cell 大小
        layout.minimumLineSpacing = 4 // 行间距
        layout.minimumInteritemSpacing = 4 // cell 之间的间距
        layout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        return layout
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
        res.register(cellWithClass: EventCollectionCell.self)
        res.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: DebugingEventHeaderView.self)
        return res
    }()
    
  
}

extension DebugingEventsViewController : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    // 返回 header 的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
          return CGSize(width: collectionView.frame.width, height: 30) // 设定大标题的高度
    }
    
    // 配置每个 section 的 header（大标题）
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withClass: DebugingEventHeaderView.self,
            for: indexPath)
        let event = self.dataSource[indexPath.section]
        headerView.display(event)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource[section].items.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withClass: EventCollectionCell.self,
            for: indexPath
        )
        let value = self.dataSource[indexPath.section].items[indexPath.row]
        cell.display(value,collectionWidth: collectionView.frame.width)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
    }
}

class EventCollectionCell : UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.equalTo(8)
            make.top.equalTo(2)
            make.trailing.equalTo(-8)
            make.bottom.equalTo(-2)
        }
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    
    func display(_ value:String,collectionWidth:CGFloat){
        titleLabel.text = value
        
        let textWidth = value.width(UIFont.systemFont(ofSize: 13))+2
        var width = max(0, textWidth)
        width = min(width, collectionWidth-32)
        
        titleLabel.snp.remakeConstraints { make in
            make.width.equalTo(width)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.top.equalTo(4)
            make.bottom.equalTo(-4)
        }
    }
    
    lazy var containerView: UIView = {
        let res = UIView(frame: .zero)
        res.backgroundColor = .lightGray
        res.layer.cornerRadius = 8
        return res
    }()
    
    lazy var titleLabel: UILabel = {
        let res = UILabel()
        res.font = UIFont.systemFont(ofSize: 13)
        res.textColor = .white
        res.text = ""
        res.numberOfLines = 0
        return res
    }()
    
}

// 自定义 UICollectionReusableView 来展示 section 的 header（大标题）
class DebugingEventHeaderView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .lightGray
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(16)
        }
    }
    
    func display(_ event:DebugingEvent) {
        titleLabel.text = event.name
        if event.type == .event {
            self.backgroundColor = .lightGray
        } else {
            self.backgroundColor = .gray
        }
        
    }
    
    lazy var titleLabel: UILabel = {
        let res = UILabel(frame: .zero)
        res.textColor = .white
        res.font = UIFont.boldSystemFont(ofSize: 15)
        res.numberOfLines = 1
        return res
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

