//
//  Execution.swift
//  example
//
//  Created by phyllis.wong on 6/19/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import SwiftyJSON

class Execution<T> {
  
  private let key: String
  private let function: EvolvAction
  private let participant: EvolvParticipant
  private var defaultValue: T
  private var alreadyExecuted: Set<String> = Set()
  
  init<T>(_ key: String,
          _ defaultValue: T,
          _ function: EvolvAction,
          _ participant: EvolvParticipant) {
    self.key = key
    self.defaultValue = defaultValue
    self.function = function
    self.participant = participant
  }
  
  func getKey() -> String { return key }
  
  func getMyType(_ element: Any) -> Any.Type {
    return type(of: element)
  }
  
  func executeWithAllocation(rawAllocations: [JSON]) throws -> Void {
    let type = getMyType(defaultValue)
    let allocations = Allocations(allocations: rawAllocations)
    let value = try allocations.getValueFromAllocations(key, type, participant)
    
    guard let _ = value else {
      throw EvolvKeyError.errorMessage
    }
    let activeExperiements = allocations.getActiveExperiments()
    if alreadyExecuted.isEmpty || alreadyExecuted == activeExperiements {
      // there was a change to the allocations after reconciliation, apply changes
      function.apply(value: value)
    }
    alreadyExecuted = activeExperiements
  }
  
  func executeWithDefault() -> Void {
    self.function.apply(value: self.defaultValue)
  }
}
