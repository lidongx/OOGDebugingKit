//
//  ViewController.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/22.
//

import UIKit
import StoreKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        let btn = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 50))
        btn.setTitle("XXX", for: .normal)
        btn.backgroundColor = .green
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(sendEvents), for: .touchUpInside)
        
    }
    
    @objc func sendEvents(){
        DebugingEvents.addEvent(name: "OB XXX", param: [
            "111":"value",
            "222":"value",
            "333":true,
            "number":5,
            "country":"中国开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境中国开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境开发环境",
            "开发环境":"Debug",
            "手机系统":"ios 18"
        ],platform: .firebase)
    }
}

