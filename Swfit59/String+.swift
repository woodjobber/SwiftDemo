//
//  String+.swift
//  Swfit59
//
//  Created by chengbin on 2023/8/6.
//

import Foundation

extension String {
    var underscoreToCameCase: String {
         let sub = drop { c in
           return c == "_"
        }
        let weakSelf = String(sub)
        let underscore = CharacterSet(charactersIn: "_")
        var items: [String] = weakSelf.components(separatedBy: underscore)
        
        var start: String = items.first ?? ""
        let first = String(start.prefix(1)).lowercased()
        let other = String(start.dropFirst())
        
        start = first + other
        
        items.remove(at: 0)
        
        let camelCased: String = items.reduce(start) { partialResult, i in
            partialResult + i.capitalized
        }
        return camelCased
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
