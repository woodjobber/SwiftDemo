//
//  ToDoListViewModel.swift
//  Swfit59
//
//  Created by chengbin on 2023/8/6.
//

import Foundation

struct ToDoListViewModel {
    private let model: LoadableModel<[Todo]>
    private let interactor: TodoListInteractor
    private let coordinator: ToDoListCoordinator
    
    let cellViewModels: [String]?
    
    var title: String {
        return "ToDo"
    }
    
    var isLoading: Bool {
        guard case .loading = model else {
            return false
        }
        return true
    }
    
    init(model: LoadableModel<[Todo]>, interactor: TodoListInteractor, coordinator: ToDoListCoordinator) {
        self.model = model
        self.interactor = interactor
        self.coordinator = coordinator
        self.cellViewModels = model.value?.flatMap {
            [$0.name] + ($0.subTasks?.map {
                " - \($0.name)"
            } ?? [])
        }
    }
    
    func load() {
        interactor.load()
    }
}
