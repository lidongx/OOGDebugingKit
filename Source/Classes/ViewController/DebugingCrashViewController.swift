//
//  DebugingCrashViewController.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/24.
//

import Foundation
import UIKit
import Combine
class DebugingCrashViewController : DebugingBaseViewController {
    
    var dataSource = DebugingCrashs.items
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.reloadData()
    }

    lazy var tableView:UITableView =  {
        let res = UITableView(frame: .zero, style: .plain)
        res.delegate = self
        res.dataSource = self
        res.estimatedRowHeight = 44
        res.backgroundColor = .clear
        res.showsVerticalScrollIndicator = false
        res.register(cellWithClass: DebugingCrashItemCell.self)
        res.separatorStyle = .singleLine
        return res
    }()
}

extension DebugingCrashViewController : UITableViewDelegate, UITableViewDataSource{
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
            withClass: DebugingCrashItemCell.self,
            for: indexPath
        )
        let type = self.dataSource[indexPath.row]
        cell.display(type: type)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        showDialog { [weak self] in
            guard let self = self else {
                return
            }
            let type = self.dataSource[indexPath.row]
            executeCrash(type: type)
        }
    }
    
    func executeCrash(type:DebugingCrashType){
        switch type {
        case .indexOutOfRange:
            DebugingCrashs.indexOutofRangeCrash()
        case .forcedUnwrapping:
            DebugingCrashs.forcedUnwrappingCrash()
        case .nilDereferencing:
            DebugingCrashs.nilDereferencingCrash()
        case .divisionByZero:
            DebugingCrashs.divisionByZeroCrash()
        case .raceCondition:
            DebugingCrashs.raceConditionCrash()
        case .stackOverflow:
            DebugingCrashs.stackOverflowCrash()
        case .outOfMemory:
            DebugingCrashs.outOfMemoryCrash()
        case .keyValueObserving:
            DebugingCrashs.keyValueObservingCrash()
        }
    }
    
    func showDialog(_ callback:(()->Void)? = nil){
        let alert = UIAlertController(title: "崩溃", message: "确定调用奔溃函数", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            callback?()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

class DebugingCrashItemCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(24)
        }
    }
    
    func display(type: DebugingCrashType){
        titleLabel.text = type.displayName
    }

    lazy var titleLabel: UILabel = {
        let res = UILabel(frame: .zero)
        res.textColor = .black
        res.font = UIFont.boldSystemFont(ofSize: 15)
        res.numberOfLines = 1
        return res
    }()

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
