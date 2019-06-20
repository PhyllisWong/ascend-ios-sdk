//
//  Allocations.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import DynamicJSON

public class Allocations {
  let allocations: [JSON]
  let audience : Audience = Audience()
  
  init (allocations: [JSON]) {
    self.allocations = allocations
  }
  
  func getMyType<T>(_ element: T) -> Any? {
    return type(of: element)
  }
  
  func getValueFromAllocations<T>(key: String, type: T, participant: AscendParticipant) throws -> [String] {
    let keyParts: [String] = key.components(separatedBy: "\\.")
    if (keyParts.isEmpty()) {
      throw AscendKeyError(rawValue: "Key provided was empty.")!
    }
    return keyParts
  }
}
