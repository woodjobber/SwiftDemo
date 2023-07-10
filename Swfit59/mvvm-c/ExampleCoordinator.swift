//
//  ExampleCoordinator.swift
//  Swfit59
//
//  Created by chengbin on 2023/8/9.
//

import Foundation
import UIKit

class ExampleCoordinator: Coordinator {
    override func createRootViewController() -> UIViewController {
        return ViewController.instantiate()
    }
}

extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
