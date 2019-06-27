//
//  ExecutionQueue.swift
//  example
//
//  Created by phyllis.wong on 6/26/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ExecutionQueue {
  private var queue = LinkedQueue<Execution>()
  
  init () {}
  
  func enqueue(execution: Execution<GenericValue<Any>>) {
    self.queue.add(execution)
  }
  
  func executeAllWithValuesFromAllocations(allocations: [JSON]) {
    while !queue.isEmpty {
      let execution: Execution = queue.remove()!
      
      do {
        try execution.executeWithAllocation(rawAllocations: allocations)
      } catch {
        let message = "There was an error retrieving the value of \(execution.getKey()) from the allocation."
        Log.logger.log(.debug, message: message)
        execution.executeWithDefault()
      }
    }
  }
  
  func executeAllWithValuesFromDefaults() {
    while !queue.isEmpty {
      let execution: Execution = queue.remove()!
      execution.executeWithDefault()
    }
  }
}
