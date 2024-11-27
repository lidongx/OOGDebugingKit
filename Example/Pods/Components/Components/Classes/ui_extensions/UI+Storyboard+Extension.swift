//
//  UI+Storyboard.swift
//  Components
//
//  Created by lidong on 2023/7/4.
//

import Foundation
import UIKit

public extension UIStoryboard{
    static var launchView : UIView?{
        if let vc = UIStoryboard(name: "LaunchScreen", bundle: Bundle.main).instantiateInitialViewController()  {
            return vc.view
        }
        return nil
    }
}

