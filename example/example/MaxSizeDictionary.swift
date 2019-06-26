//
//  MaxSizeDictionary.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

// This solves the problem of not overloading virtual memory on the device
public struct MaxSizeDictionary<T: Hashable, U> {
  private let _limit: UInt
  private var dictionary = [T: U]()
  
  init(limit: UInt) {
    self._limit = limit
  }
  
  subscript(key: T) -> U? {
    get {
      return dictionary[key]
    }
    set {
      let keys = dictionary.keys
      if keys.count < _limit || keys.contains(key) {
        dictionary[key] = newValue
      }
    }
  }
  func getDictionary() {}
}
