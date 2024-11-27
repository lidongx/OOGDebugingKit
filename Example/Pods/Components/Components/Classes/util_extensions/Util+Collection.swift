//
//  Util+Collection.swift
//  Components
//
//  Created by lidong on 2024/6/5.
//

import Foundation

public extension Collection {
  /// Returns the element at the specified index if it exists, otherwise nil.
  subscript(safe index: Index) -> Element? {
    return self.indices.contains(index) ? self[index] : nil
  }
}
