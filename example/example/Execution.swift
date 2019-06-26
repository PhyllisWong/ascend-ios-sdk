//
//  Execution.swift
//  example
//
//  Created by phyllis.wong on 6/19/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol AscendAction {
  /**
   * Applies a given value to a set of instructions.
   * @param value any value that was requested
   */
  func apply<T>(value: T) -> Void
}

struct Set<Element> where Element : Hashable {}

class Execution<T> {
  
  private let key: String
  private let defaultValue: T // Generic
  private let function: (T) -> T
  private let participant: AscendParticipant
  
  private var alreadyExecuted: Set<String> = Set()
  
  init(key: String, defaultValue: T,
       function: @escaping (T) -> T,
       participant: AscendParticipant) {
    self.key = key
    self.defaultValue = defaultValue
    self.function = function
    self.participant = participant
  }
  
  func getKey() -> String { return key }
  
  func getMyType(_ element: Any) -> Any.Type {
    return type(of: element)
  }
  
  func executeWithAllocation(rawAllocations: JsonArray) throws -> Void {
    let type = getMyType(defaultValue)
    let allocations = Allocations(allocations: rawAllocations)
    // let type = (cls.element).getMyType()
    // let value = allocations.getValueFromAllocations(key: key, type: (cls.element as AnyObject).getMyType(), participant: participant)
  }
  
  func executeWithDefault(_ default: T) -> Void {
    self.function(defaultValue)
  }
  
}
