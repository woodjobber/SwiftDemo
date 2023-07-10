//
//  TodoListInteractor.swift
//  Swfit59
//
//  Created by chengbin on 2023/8/6.
//

import Foundation

class TodoListInteractor: Interactor {
    var modelDidUpdate: (() -> Void)?
    
    private(set) var model: LoadableModel<[Todo]> = .none {
        didSet {
            modelDidUpdate?()
        }
    }
    
    
    func load() {
        model = model.byStartLoading()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [unowned self] in
            let r = Int.random(in: 10...100)
            let todos = [
                Todo(name: "Renew\(r)", subTasks: nil),
                Todo(name: "G\(r)", subTasks: [Todo(name: "G1", subTasks: nil)]),
                Todo(name: "A\(r)", subTasks: nil),
                Todo(name: "B\(r)", subTasks: nil),
                Todo(name: "C\(r)", subTasks: nil),
            ]
            var _m = self.model.value ?? []
            _m.append(contentsOf: todos)
            self.model = self.model.byStopLoading(newValue: _m)
        }
    }
}
