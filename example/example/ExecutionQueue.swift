//
//  ExecutionQueue.swift
//  example
//
//  Created by phyllis.wong on 6/26/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import SwiftyJSON

class ExecutionQueue {
  // need an instance of the logger
  private var queue = LinkedQueue<Execution>()
  
  init () {}
  
  func enqueue(execution: Execution<GenericValue<Any>>) {
    self.queue.add(execution)
  }
  
  func executeAllWithValuesFromAllocations(allocations: [JSON]) {
    while !queue.isEmpty {
      let execution: Execution = queue.remove()! // safely unwrap this
      
      do {
        try execution.executeWithAllocation(rawAllocations: allocations)
      } catch {
        // log here
        execution.executeWithDefault()
      } catch {
        // log here
        
      }
    }
  }
  
  
  func executeAllWithValuesFromDefaults() {
    while !queue.isEmpty {
      let execution: Execution = queue.remove()! // safely unwrap this nil value
      execution.executeWithDefault()
    }
  }
  
}

// TODO: move to utils folder
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
