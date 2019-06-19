//
//  AscendClientImpl.swift
//  example
//
//  Created by phyllis.wong on 6/18/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

class AscendClientImpl { // : AscendClient {
  
  private let logger = Log.logger
  private let allocator: Allocator
  private let store: AscendAllocationStore
  private let previousAllocations: Bool
  private let participant: AscendParticipant
  
  init(config: AscendConfig, allocator: Allocator, previousAllocations: Bool, participant: AscendParticipant) {
    self.store = config.getAscendAllocationStore()
    self.allocator = allocator
    self.previousAllocations = previousAllocations
    self.participant = participant
  }
  
  
  func get<T>(key: String, defaultValue: T) {
    
  }
  
}
