//
//  DebugingOtherButtonsConfig.swift
//  OOGDebugingKit
//
//  Created by lidong on 2024/10/29.
//

import Foundation
import UIKit

class DebugingOtherButtonConfigs {
    static var items:[DebugingOtherButtonConfig] = []
}

public class DebugingOtherButtonConfig {
    var buttonText:String
    var callback:((UIButton)->Void)
    
    public var button:UIButton!

    public init(
        buttonText: String,
        callback: @escaping ((UIButton) -> Void)
    ) {
        self.buttonText = buttonText
        self.callback = callback
        
        self.button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        self.button.setTitle(buttonText, for: .normal)
        self.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.button.setTitleColor(.orange, for: .normal)
        self.button.borderWidth = 2
        self.button.cornerRadius = 8
        self.button.configuration = UIButton.Configuration.bordered()
        self.button.configuration?.titlePadding = 8
        self.button.borderColor = UIColor.darkGray.cgColor
    }
}

