//
//  RxUIApplicationDelegateProxy.swift
//  Swfit59
//
//  Created by chengbin on 2023/8/7.
//

import UIKit
import RxCocoa
import RxSwift

public class RxUIApplicationDelegateProxy: DelegateProxy<UIApplication,UIApplicationDelegate>,UIApplicationDelegate,DelegateProxyType {
    
    public weak private(set) var application: UIApplication?
    
    init(application: ParentObject) {
        self.application = application
        super.init(parentObject: application, delegateProxy: RxUIApplicationDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { p in
            return RxUIApplicationDelegateProxy(application: p)
        }
    }
    
    public static func currentDelegate(for object: UIApplication) -> UIApplicationDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: UIApplicationDelegate?, to object: UIApplication) {
        object.delegate = delegate
    }
    
    public override func setForwardToDelegate(_ delegate: DelegateProxy<UIApplication, UIApplicationDelegate>.Delegate?, retainDelegate: Bool) {
        super.setForwardToDelegate(delegate, retainDelegate: true)
    }
}

public enum AppState {
    case active
    case inactive
    case background
    case teminated
}

extension UIApplication.State {
    func toAppState() -> AppState {
        switch self {
        case .active:
            return .active
        case .inactive:
            return .inactive
        case .background:
            return .background
        @unknown default:
            return .teminated
        }
    }
}

extension Reactive where Base: UIApplication {
    var delegate: DelegateProxy<UIApplication,UIApplicationDelegate> {
        return RxUIApplicationDelegateProxy.proxy(for: base)
    }
    
    var didBecomeActive: Observable<AppState> {
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationDidBecomeActive(_:))).map { _ in
            return .active
        }
    }
    
    var willResignActive: Observable<AppState> {
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationWillResignActive(_:))).map { _ in
                .inactive
        }
    }
    
    var willEnterForeground: Observable<AppState> {
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationWillEnterForeground(_:))).map { _ in
                .inactive
        }
    }
    
    var didEnterBackground: Observable<AppState> {
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationDidEnterBackground(_:))).map { _ in
                .background
        }
    }
    
    var willTerminate: Observable<AppState> {
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationWillTerminate(_:))).map { _ in
                .teminated
        }
    }
    
    var state: Observable<AppState> {
        return Observable.of(didBecomeActive,willResignActive,willEnterForeground,willTerminate,didEnterBackground).merge().startWith(base.applicationState.toAppState())
    }
    
}
