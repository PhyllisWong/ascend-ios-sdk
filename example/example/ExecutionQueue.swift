//
//  ExecutionDispatch.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation


import Foundation
protocol ExecutionDispatcher {}

public class ExecutionQueue {
  private let queue: DispatchQueue
  private var workItem: DispatchWorkItem?
  
  init(queue: DispatchQueue) {
    self.queue = DispatchQueue.global(qos: .utility)
  }
  
//  func enqueue(execution: Execution<Any>) -> Void {
//    workItem = DispatchWorkItem {
//      self.queue.async(execute: execution)
//    }
//  }
}
