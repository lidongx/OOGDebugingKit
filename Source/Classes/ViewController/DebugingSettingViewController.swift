//
//  DebugingSettingViewController.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/24.
//

import Foundation
import UIKit

class DebugingSettingViewController : DebugingBaseViewController {
    
    var dataSource = DebugingSettings.items
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    lazy var tableView:UITableView =  {
        let res = UITableView(frame: .zero, style: .plain)
        res.delegate = self
        res.dataSource = self
        res.estimatedRowHeight = 44
        res.backgroundColor = .clear
        res.showsVerticalScrollIndicator = false
        res.register(cellWithClass: DebugingSettingCell.self)
        res.separatorStyle = .singleLine
        return res
    }()
    
 
    
}

extension DebugingSettingViewController : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(
            withClass: DebugingSettingCell.self,
            for: indexPath
        )
        let type = self.dataSource[indexPath.row]
        cell.display(type)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
    }
}

class DebugingSettingCell: UITableViewCell {
    
    var type:DebugingSettingType = .fps
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(24)
        }
    
        contentView.addSubview(switcher)
        switcher.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-8)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
    }
    
    func display(_ type:DebugingSettingType){
        self.type = type
        titleLabel.text = type.display
        switcher.isOn = type.opened
    }
    
    
    lazy var titleLabel: UILabel = {
        let res = UILabel(frame: .zero)
        res.textColor = .black
        res.font = .oog(.bold, 15)
        res.numberOfLines = 1
        return res
    }()
    
    lazy var switcher: UISwitch = {
        let res = UISwitch(frame: .zero)
        res.addTarget(
                self,
                action: #selector(switchValueChanged(_:)),
                for: .valueChanged
            )
        return res
    }()
    
    
    @objc func switchValueChanged(_ sender: UISwitch){
        self.type.opened = sender.isOn
        UIWindow.panelWindow.openedStateChanged()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
