//
//  DebugingBaseViewController.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/24.
//

import Foundation
import UIKit
class DebugingBaseViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(1)
        }
    }
    
    lazy var lineView: UIView = {
        let res = UIView(frame: .zero)
        res.backgroundColor = .lightGray
        return res
    }()
}
