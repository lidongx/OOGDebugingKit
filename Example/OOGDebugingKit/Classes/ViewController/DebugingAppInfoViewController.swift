//
//  DebugingAppInfoViewController.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/22.
//

import Foundation
import UIKit

class DebugingAppInfoViewController : UIViewController {
    
    var datasouce = DebugingAppInfos.sections
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        tableView.reloadData()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
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
                make.width.lessThanOrEqualTo(280)
            }
        }
        
        func display(_ item:DebugingAppInfoItem){
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




