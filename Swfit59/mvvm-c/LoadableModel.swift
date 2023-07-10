//
//  LoadableModel.swift
//  Swfit59
//
//  Created by chengbin on 2023/8/6.
//

import Foundation

enum LoadableModel<T> {
    case none
    case loading(T?)
    case some(T)
    case error(Error)
    
    var value: T? {
        switch self {
        case let .some(value),let .loading(.some(value)):
            return value
        case .loading,.none, .error:
            return nil
        }
    }
    
    func byStartLoading() -> LoadableModel {
        return .loading(value)
    }
    
    func byStopLoading(newValue: T? = nil, error: Error? = nil) -> LoadableModel<T> {
        if let value = newValue ?? self.value {
            return .some(value)
        }else if let error = error {
            return .error(error)
        }
        return .none
    }
}
