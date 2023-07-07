//
//  NSObjectProtocol+.swift
//  Swfit59
//
//  Created by chengbin on 2023/7/7.
//

import Foundation

extension NSObjectProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}
