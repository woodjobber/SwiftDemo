//
//  Array+.swift
//  Swfit59
//
//  Created by chengbin on 2023/7/8.
//

import Foundation

extension Array where Element: Equatable {
    typealias E = Element

    func subtracting(_ other: [E]) -> [E] {
        return self.compactMap { element in
            if (other.filter { $0 == element }).count == 0 {
                return element
            }
            return nil
        }
    }

    mutating func subtract(_ other: [E]) {
        self = self.subtracting(other)
    }

    mutating func remove(value: Element) {
        // typealias Index = Int
        if let i = self.firstIndex(of: value) {
            self.remove(at: i)
        }
    }
}
