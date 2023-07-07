//
//  UIApplication+.swift
//  Swfit59
//
//  Created by chengbin on 2023/7/7.
//

import Foundation
import UIKit

extension UIApplication
{
    class var topViewController: UIViewController?
    {
        return getTopViewController()
    }

    var topViewController: UIViewController?
    {
        return UIApplication.getTopViewController()
    }

    var keyWindow: UIWindow?
    {
        if #available(iOS 13.0, *)
        {
            if let window = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows
                .filter({ $0.isKeyWindow }).first
            {
                return window
            }

            if let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first?.windows.filter({ $0.isKeyWindow }).first {
                return window
            }
            
            if let window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
            {
                return window
            }
            return UIApplication.shared.delegate?.window ?? nil
        }
        else
        {
            return UIApplication.shared.delegate?.window ?? UIApplication.shared.windows.first(where: \.isKeyWindow)
        }
    }

    private class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController { return getTopViewController(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController
        {
            if let selected = tab.selectedViewController { return getTopViewController(base: selected) }
        }
        if let presented = base?.presentedViewController { return getTopViewController(base: presented) }
        return base
    }

    private class func _share(_ data: [Any],
                              applicationActivities: [UIActivity]?,
                              setupViewControllerCompletion: ((UIActivityViewController) -> Void)?)
    {
        let activityViewController = UIActivityViewController(activityItems: data, applicationActivities: applicationActivities)
        setupViewControllerCompletion?(activityViewController)
        UIApplication.topViewController?.present(activityViewController, animated: true, completion: nil)
    }

    class func share(_ data: Any...,
                     applicationActivities: [UIActivity]? = nil,
                     setupViewControllerCompletion: ((UIActivityViewController) -> Void)? = nil)
    {
        _share(data, applicationActivities: applicationActivities, setupViewControllerCompletion: setupViewControllerCompletion)
    }

    class func share(_ data: [Any],
                     applicationActivities: [UIActivity]? = nil,
                     setupViewControllerCompletion: ((UIActivityViewController) -> Void)? = nil)
    {
        _share(data, applicationActivities: applicationActivities, setupViewControllerCompletion: setupViewControllerCompletion)
    }
}
