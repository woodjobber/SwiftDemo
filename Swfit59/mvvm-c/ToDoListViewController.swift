//
//  ToDoListViewController.swift
//  Swfit59
//
//  Created by chengbin on 2023/8/6.
//

import Foundation
import UIKit
import RxSwift

class TodoListViewController: UITableViewController, UpdateableView {
    private var viewModel: ToDoListViewModel
    
    required init(viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.load), for: .valueChanged)
        configure(with: viewModel)
        viewModel.load()
        
        UIApplication.shared.rx.state.subscribe(onNext: {
            state in
            switch state {
            case .active:
                print("active")
            case .inactive:
                print("inactive")
            case .background:
                print("background")
            case .teminated:
                print("terminated")
            }
        }).disposed(by: bag)
        
        Observable<UIColor>.of(.orange).bind(to: self.rx.backgroundColor).disposed(by: bag)
    }
    
    @objc private func load() {
        viewModel.load()
    }
    
    func configure(with viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
        title = viewModel.title
        tableView.reloadData()
        if viewModel.isLoading {
            refreshControl?.beginRefreshing()
        }else {
            refreshControl?.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        var conf = cell.defaultContentConfiguration()
        conf.text = viewModel.cellViewModels?[indexPath.row]
        cell.contentConfiguration = conf
        cell.selectionStyle = .none
        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
