//
//  DebugingAppInfoViewController.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/22.
//

import Foundation
import UIKit
import Components
import Combine

class DebugingAppInfoViewController : DebugingBaseViewController {
    
    var datasouce = DebugingAppInfos.sections
    var item:DebugingAppInfoItem?
    var disposeBag =  Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(tableView)
        
        self.view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top
                .equalTo(UINavigationBar.barHeight+StateBar.barHeight+8)
            make.height.equalTo(40)
        }
  
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(segmentControl.snp.bottom).offset(8)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        segmentControl.selectedSegmentIndex = 0
        
        
        var index = segmentControl.selectedSegmentIndex;
        if(index < 0) {
            index = 0
        }
        self.datasouce = [DebugingAppInfos.sections[index]]
        
        Task {
            await self.updateData()
            DispatchQueue.main.async {
                self.segmentControl.selectedSegmentIndex = 0
                self.tableView.reloadData()
            }
        }
        
        bind()
    }
    
    func updateData() async {
        DebugingAppInfos.updateNetworkState()
        var state = await DebugingAppInfos.getNotiAuthority()
        DebugingAppInfos.setNotiState(state)
        state = DebugingAppInfos.getATTAuthority()
        DebugingAppInfos.setATTState(state)
        var value = DebugingAppInfos.getAppMemoryUsage()
        DebugingAppInfos.setAppMemoryUsage(value)
        value = DebugingAppInfos.getAppDiskSpaceSize()
        DebugingAppInfos.setAppDiskSpaceUsage(value)
        value = DebugingFrameRate.shared.fpsString
        DebugingAppInfos.setAppFrameRate(value)
    }
    
    func bind(){
        DebugingFrameRate.shared.$fpsString
            .receive(on: DispatchQueue.main)
            .sink { value in
                if let cells = self.tableView.visibleCells as? [DebugingInfoViewCell] {
                    for cell in cells where cell.item?.type == .fps{
                        cell.valueLabel.text = value
                    }
                }
            }
            .store(in: &disposeBag)
        
        DebugingMemoryChecker.shared.$memoryUsage
            .receive(on: DispatchQueue.main)
            .sink { value in
                if let cells = self.tableView.visibleCells as? [DebugingInfoViewCell] {
                    for cell in cells where cell.item?.type == .appMemoryUsage{
                        cell.valueLabel.text = value
                    }
                }
            }
            .store(in: &disposeBag)
    }
    
    @objc func segmentControlValueChanged(){
        let value = DebugingFrameRate.shared.fpsString
        DebugingAppInfos.setAppFrameRate(value)
        self.datasouce = [DebugingAppInfos.sections[segmentControl.selectedSegmentIndex]]
        self.tableView.reloadData()
    }
    
    
    lazy var segmentControl: UISegmentedControl = {
        let texts = DebugingAppInfos.sections.map{ $0.sectionType.display }
        let res = UISegmentedControl(items: texts)
        res.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
        return res
    }()

    
    lazy var tableView:UITableView =  {
        let res = UITableView(frame: .zero, style: .plain)
        res.delegate = self
        res.dataSource = self
        res.estimatedRowHeight = 60
        res.backgroundColor = .clear
        res.showsVerticalScrollIndicator = false
        res.register(cellWithClass: DebugingInfoViewCell.self)
        res.separatorStyle = .singleLine
        return res
    }()
}

extension DebugingAppInfoViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.datasouce.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.datasouce[section].sectionType.display
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasouce[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: DebugingInfoViewCell.self, for: indexPath)
        let item = self.datasouce[indexPath.section].items[indexPath.row]
        cell.display(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension DebugingAppInfoViewController {

    class DebugingInfoViewCell: UITableViewCell {
        var item:DebugingAppInfoItem?
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(24)
            }
            
            addSubview(valueLabel)
            valueLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(-8)
                make.width.lessThanOrEqualTo(240)
            }
        }
        
        func display(_ item: DebugingAppInfoItem){
            self.item = item
            self.titleLabel.text = item.type.displayName + ":"
            self.valueLabel.text = item.value
        }
        
        
        lazy var titleLabel: UILabel = {
            let res = UILabel(frame: .zero)
            res.textColor = .black
            res.font = .oog(.medium, 15)
            res.numberOfLines = 1
            return res
        }()
        
        lazy var valueLabel: UILabel = {
            let res = UILabel(frame: .zero)
            res.textColor = .black
            res.font = .oog(.medium, 15)
            res.numberOfLines = 0
            return res
        }()
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}




