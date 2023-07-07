//
//  Nibable.swift
//  Swfit59
//
//  Created by chengbin on 2023/7/7.
//

import Foundation
import UIKit

protocol Nibable: NSObjectProtocol {
    static var nibName: String { get }
    static var nib: UINib { get }
}

extension Nibable {
    static var nibName: String {
        return className
    }

    static var nib: UINib {
        return UINib(nibName: nibName, bundle: Bundle(for: Self.self))
    }
}
