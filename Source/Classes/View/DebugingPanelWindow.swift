//
//  DebugingPanleWindow.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/25.
//

import Foundation
import UIKit
import Combine
import Components
import FIREvents
class DebugingPanelWindow :  DebugingMovingWindow {
    
    static let windowHieght:CGFloat = 200
    
    
    var disposeBag = Set<AnyCancellable>()
    var onCloseAction:(()->Void)? = nil
    
    private let offset = PadddingOffset(
        top: SafeArea.top,
        bottom: SafeArea.bottom+30,
        left: 0,
        right: 0
    )
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }

    func loadUI() {
        self.backgroundColor = .black
        
        addSubview(topContainer)
        topContainer.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(30)
        }
        
        topContainer.addSubview(fpsLabel)
        fpsLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(4)
        }
        
        topContainer.addSubview(memoryUseLabel)
        memoryUseLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-4)
        }
        topContainer.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(26)
        }
        
        self.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(segmentControl.snp.bottom).offset(8)
        }
        
        segmentControl.selectedSegmentIndex = 0
        bottomView.dataSource = DebugingEvents.mixpanelEvents.reversed()
        
        bind()
        
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(dataSourceUpdated), name: Notification
                .Name(DebugingEvents.notificationKey),
            object: nil
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
            self.openedStateChanged()
        })
        
    }
    
    @objc func dataSourceUpdated(){
        segmentValueChanged()
    }
    
    func bind(){
        DebugingFrameRate.shared.$fpsString
              .receive(on: DispatchQueue.main)
              .map { $0 }
              .assign(to: \.text, on: fpsLabel)
              .store(in: &disposeBag)
        
        DebugingMemoryChecker.shared.$memoryUsage
            .receive(on: DispatchQueue.main)
            .map{ $0 }
            .assign(to: \.text, on: memoryUseLabel)
            .store(in: &disposeBag)
    }

    func openedStateChanged() {
        fpsLabel.isHidden = !DebugingSettingType.fps.opened
        memoryUseLabel.isHidden = !DebugingSettingType.memoryUse.opened
        segmentControl.isHidden = !DebugingSettingType.events.opened
        if fpsLabel.isHidden,memoryUseLabel.isHidden,segmentControl.isHidden {
            self.isHidden = true
        } else {
            self.isHidden = false
        }
        updateFrame()
    }
    
    func updateFrame(){
        if segmentControl.isHidden {
            self.frame = CGRect(
                x: self.frame.minX,
                y: self.frame.minY,
                width: self.frame.width,
                height: topContainer.height
            )
        } else {
            self.frame = CGRect(
                x: self.frame.minX,
                y: self.frame.minY,
                width: self.frame.width,
                height: DebugingPanelWindow.windowHieght
            )
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var topContainer: UIView = {
        let res = UIView(frame: .zero)
        res.backgroundColor = .lightGray
        return res
    }()

    lazy var fpsLabel: UILabel = {
        let res = UILabel()
        res.font = UIFont.boldSystemFont(ofSize: 11)
        res.textColor = .white
        res.text = ""
        return res
    }()
    
    lazy var memoryUseLabel: UILabel = {
        let res = UILabel()
        res.font = UIFont.boldSystemFont(ofSize: 11)
        res.textColor = .white
        res.text = ""
        res.textAlignment = .right
        return res
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let res = UISegmentedControl(items: ["Mixpanel","Firebase"])
        res.selectedSegmentTintColor = .darkGray
        res.backgroundColor = .label
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        res.setTitleTextAttributes(titleTextAttributes, for:.normal)
        res.selectedSegmentIndex = 0
        res.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        return res
    }()

    lazy var bottomView: DebugingBottomView = {
        let res = DebugingBottomView(frame: .zero)
        return res
    }()
    
    @objc func segmentValueChanged() {
        if self.segmentControl.selectedSegmentIndex == 0 {
            self.bottomView.dataSource = DebugingEvents.mixpanelEvents.reversed()
        } else if self.segmentControl.selectedSegmentIndex == 1 {
            self.bottomView.dataSource = DebugingEvents.firebaseEvents.reversed()
        }
    }
    
    override func handleTouchesEnd(distance: CGFloat) {
        super.handleTouchesEnd(distance: distance)
        //移动距离小判定为点击
        if distance < 5 {
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
}

class DebugingBottomView : UIView {
    
    @Published
    var dataSource:[DebugingEvent] = []
    
    var disposeBag = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        $dataSource.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.collectionView.reloadData()
            self?.collectionView.setContentOffset(.zero, animated: true)
        }.store(in: &disposeBag)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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


extension DebugingBottomView : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    // 返回 header 的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
          return CGSize(width: collectionView.frame.width, height: 40) // 设定大标题的高度
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
        cell.display(value,collectionWidth: collectionView.frame.size.width)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
    }
}
