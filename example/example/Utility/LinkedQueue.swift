//
//  LinkedQueue.swift
//  example
//
//  Created by phyllis.wong on 6/26/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation


public struct LinkedQueue<T> {
  
  fileprivate var list = LinkedList<T>()
  
  public var isEmpty: Bool {
    return list.isEmpty
  }
  
  public var count: Int {
    return list.count
  }
  
  public mutating func add(_ element: T) {
    list.append(element)
  }
  
  public mutating func remove() -> T? {
    if isEmpty {
      return nil
    } else {
      return list.removeLast()
    }
  }
}
