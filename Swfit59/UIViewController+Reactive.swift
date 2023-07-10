//
//  UIViewController+Reactive.swift
//  Swfit59
//
//  Created by chengbin on 2023/8/7.
//

#if os(iOS)
import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }

    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map {
            $0.first as? Bool ?? false
        }
        return ControlEvent(events: source)
    }

    var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map {
            $0.first as? Bool ?? false
        }
        return ControlEvent(events: source)
    }

    var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map {
            $0.first as? Bool ?? false
        }
        return ControlEvent(events: source)
    }

    var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map {
            $0.first as? Bool ?? false
        }
        return ControlEvent(events: source)
    }

    var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in
        }
        return ControlEvent(events: source)
    }

    var viewDidLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in
        }
        return ControlEvent(events: source)
    }

    var willMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.willMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }

    var didMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.didMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }

    var didReceiveMemoryWarning: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.didReceiveMemoryWarning)).map { _ in }
        return ControlEvent(events: source)
    }

    /// Rx observable, triggered when the ViewController appearance state changes (true if the View is being displayed, false otherwise)
    var isVisible: Observable<Bool> {
        let viewDidAppearObservable = self.base.rx.viewDidAppear.map { _ in true }
        let viewWillDisappearObservable = self.base.rx.viewWillDisappear.map { _ in false }
        return Observable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable)
    }

    /// Rx observable, triggered when the ViewController is being dismissed
    var isDismissing: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.dismiss)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    var backgroundColor: Binder<UIColor> {
        return Binder(base) { t, v in
            t.view.backgroundColor = v
        }
    }

    private static var sharedApplication: UIApplication {
        return UIApplication.shared
    }

    /// Returns the current application's top most view controller.
    static var topMost: UIViewController? {
        let keyWindow = sharedApplication.keyWindow
        let rootViewController: UIViewController? = keyWindow?.rootViewController
        return self.topMost(of: rootViewController)
}

    /// Returns the top most view controller from given view controller's stack.
    static func topMost(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }

        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController
        {
            return self.topMost(of: selectedViewController)
        }

        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController
        {
            return self.topMost(of: visibleViewController)
        }

        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
           pageViewController.viewControllers?.count == 1
        {
            return self.topMost(of: pageViewController.viewControllers?.first)
        }

        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }

        return viewController
    }
}
#endif
