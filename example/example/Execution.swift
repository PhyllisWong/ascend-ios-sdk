//
//  Execution.swift
//  example
//
//  Created by phyllis.wong on 6/19/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation


protocol AscendAction {
  /**
   * Applies a given value to a set of instructions.
   * @param value any value that was requested
   */
  func apply<T>(value: T) -> Void
}

public class GenericClass<T> {
  private let type: AnyClass
  
  public class GenericClass(type: Class<T>) {
    self.type = type
  }
  
  public func getMyType() -> AnyClass {
    return self.type
  }
}

struct Set<Element> where Element : Hashable {}

class Execution {
  
  private let key: String
  private let defaultValue: Any // Generic
  private let function: AscendAction
  private let participant: AscendParticipant
  
  private var alreadyExecuted: Set<String> = Set()
  
  init(key: String, defaultValue: Any,
       function: AscendAction,
       participant: AscendParticipant) {
    self.key = key
    self.defaultValue = defaultValue
    self.function = function
    self.participant = participant
  }
  
  func getKey() -> String { return self.key }
  
  func executeWithAllocation(rawAllocations: JsonArray) throws {
    
  }
  
  func executeWithDefault() {
    self.function.apply(value: self.defaultValue)
  }
  
}
