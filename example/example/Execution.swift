//
//  Execution.swift
//  example
//
//  Created by phyllis.wong on 6/19/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import SwiftyJSON

class Execution {
  
  private let key: String
  private let defaultValue: GenericValue<Any>
  private let function: EvolvAction
  private let participant: EvolvParticipant
  
  private var alreadyExecuted: Set<String> = Set()
  
  init<T>(key: String, defaultValue: T,
       function: EvolvAction,
       participant: EvolvParticipant) {
    self.key = key
    self.defaultValue = defaultValue as! Execution.GenericValue<Any>
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
    let value = try allocations.getValueFromAllocations(key: key, type: type, participant: participant)
    
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
  
  class GenericValue<T> {
    
    let value: T
    init(_ value: T) {
      self.value = value
    }
    
    func getMyType<T>() -> T.Type.Type {
      return type(of: T.self)
    }
  }
  
}
