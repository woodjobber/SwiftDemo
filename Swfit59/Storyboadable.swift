//
//  Storyboadable.swift
//  Swfit59
//
//  Created by chengbin on 2023/7/7.
//

import Foundation
import UIKit

protocol Storyboardable: NSObjectProtocol {
    static var storyboardName: String { get }

    static func instantiate() -> Self
}

extension Storyboardable {
    static var storyboardName: String {
        return className
    }

    static func instantiate() -> Self {
        return UIStoryboard(name: storyboardName, bundle: Bundle(for: Self.self)).instantiateInitialViewController() as! Self
    }
}
