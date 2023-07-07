//
//  Collection+.swift
//  Swfit59
//
//  Created by chengbin on 2023/7/8.
//

import Foundation

extension Collection {
    func find(includeElement: (Self.Iterator.Element) -> Bool) -> Self.Iterator.Element? {
        if let index = index(of: includeElement) { return self[index] }
        return nil
    }

    func index(of includeElement: (Self.Iterator.Element) -> Bool) -> Index? {
        return firstIndex(where: includeElement)
    }
}
