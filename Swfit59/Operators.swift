//
//  Operators.swift
//  Swfit59
//
//  Created by chengbin on 2023/7/8.
//

import Foundation

prefix operator ^
prefix func ^ <Root, Value>(keyPath: KeyPath<Root, Value>) -> (Root) -> Value {
  return { root in root[keyPath: keyPath] }
}
