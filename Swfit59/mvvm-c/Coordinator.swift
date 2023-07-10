//
//  Coordinator.swift
//  Swfit59
//
//  Created by chengbin on 2023/8/5.
//

import Foundation
import UIKit
class Coordinator {

    private weak var _rootViewController: UIViewController?

    var rootViewController: UIViewController {
        return _rootViewController ?? createRootViewController()
    }

    func createRootViewController() -> UIViewController {
        fatalError("createRootViewController not implemented")
    }
}

protocol Interactor: AnyObject {
    associatedtype ModelType
    var model: ModelType { get }
    var modelDidUpdate: (() -> Void)? { get set }
}

protocol UpdateableView: AnyObject {
    associatedtype ViewModelType
    init(viewModel: ViewModelType)
    func configure(with viewModel: ViewModelType)
}

extension Interactor {
    func bind<T: UpdateableView>(with viewController: T, factory: @escaping (_ interactor: Self, _ vc: T) -> Void) {
        modelDidUpdate = {
            [weak self, weak viewController] in
                guard let interactor = self, let viewController = viewController else {
                    return
                }
                factory(interactor, viewController)
        }
    }
}
