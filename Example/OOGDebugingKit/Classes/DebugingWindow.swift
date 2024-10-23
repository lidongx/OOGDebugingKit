//
//  FloatingWindow.swift
//  TestSPM
//
//  Created by lidong on 2024/4/12.
//

import Foundation
import UIKit
import Combine
public class DebugingWindow :  UIWindow {
    @Published
    public var showing: Bool = false
    var disposeBag = Set<AnyCancellable>()

    var onCloseAction:(()->Void)? = nil
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
        bind()
    }

    func loadUI() {
        self.backgroundColor = .clear
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        vc.view.isUserInteractionEnabled = false
        self.rootViewController = vc
    }

    func bind() {
        $showing.receive(on: DispatchQueue.main).sink { [weak self] value in
            if value {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    self?.isHidden = !value
                    self?.showFloatingViewController()
                })
            }
        }.store(in: &disposeBag)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showFloatingViewController(){
        let vc = DebugingViewController()
        let nav = DebugingNavViewController(rootViewController: vc)
        vc.closeActionCallback = { [weak self] in
            self?.isHidden = true
            self?.onCloseAction?()
        }
        nav.modalPresentationStyle = .fullScreen
        self.topViewController()?.present(nav, animated: true)
    }
}

class DebugingNavViewController : UINavigationController{
    var viewDidDisappearCallback:(()->Void)? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDidDisappearCallback?()
    }
}
