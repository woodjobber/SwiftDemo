//
//  TodoListCoordinator.swift
//  Swfit59
//
//  Created by chengbin on 2023/8/6.
//

import Foundation
import UIKit

class ToDoListCoordinator: Coordinator {
    override func createRootViewController() -> UIViewController {
        let interactor = TodoListInteractor()
        let viewModel = ToDoListViewModel(model: interactor.model, interactor: interactor, coordinator: self)
        let viewController = TodoListViewController(viewModel: viewModel)
        interactor.bind(with: viewController) { interactor, vc in
            let viewModel = ToDoListViewModel(model: interactor.model, interactor: interactor, coordinator: self)
            vc.configure(with: viewModel)
        }
        return viewController
    }
}
