//
//  UIViewController+.swift
//  Swfit59
//
//  Created by chengbin on 2023/7/7.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.topViewController
        if var tc = topController {
            while tc.presentedViewController != nil {
                if let present = tc.presentedViewController {
                    tc = present
                }
            }
            topController = tc
        }
        return topController
    }
}



