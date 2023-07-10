//
//  AppCoordinator.swift
//  Swfit59
//
//  Created by chengbin on 2023/8/5.
//

import UIKit

class AppCoordinator: Coordinator {
    var parent: Coordinator?
    
    var window: UIWindow!
 
    func start() {
        parent = ExampleCoordinator()
        
        window.rootViewController = UINavigationController(rootViewController: parent!.rootViewController)
        window.makeKeyAndVisible()
    }
    
    let score = 800
    init(window: UIWindow) {
        self.window = window
        super.init()
        let complexResult = self.rating(for: score)
        print(complexResult)
        
        
    }
    
    func rating(for score: Int) -> String {
        switch score {
        case 0...300: "Fail"
        case 301...500: "Pass"
        case 501...800: "Merit"
        default: "Distinction"
        }
    }
    
 
}
// http://www.csl.cool/2023/06/05/ios-dev/swift/swift-noncopyable-types-and-variable-ownership/
struct User : ~Copyable{
    var name: CInt

    deinit {
        print("+++++")
    }
    // consuming: 所有权变化，borrowing:所有权不变,只读
    consuming func consume(){
     
     
    }
    borrowing func borrow(){
        
    }
    mutating func mutate() {
        let copy = self
        self = copy
    }
}

struct SingleStruct: ~Copyable {
    var age: Int = 100
    var name:Int  = 100
    consuming func consume() {}
    deinit {
        print("single deinit age: \(age)")
    }
}
