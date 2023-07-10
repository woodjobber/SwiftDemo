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
    
    static func instantiate(_ identifier: String) -> Self
    
    static var identifier: String {get}
}

extension Storyboardable {
    static var storyboardName: String {
        return className
    }

    static var identifier: String {
        return className
    }
    
    static func instantiate() -> Self {
        return UIStoryboard(name: storyboardName, bundle: Bundle(for: Self.self)).instantiateViewController(withIdentifier: identifier) as! Self
    }
    
    static func instantiate(_ identifier: String) -> Self {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! Self
    }
}
