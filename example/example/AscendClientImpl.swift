//
//  AscendClientImpl.swift
//  example
//
//  Created by phyllis.wong on 6/18/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import DynamicJSON

class AscendClientImpl : AscendClient {
  
  private let eventEmitter: EventEmitter
  private let futureAllocations: [JSON]
  private let logger = Log.logger
  private let allocator: Allocator
  private let store: AscendAllocationStore
  private let previousAllocations: Bool
  private let participant: AscendParticipant
  
  init(config: AscendConfig, allocator: Allocator,
       previousAllocations: Bool, participant: AscendParticipant,
       eventEmitter: EventEmitter, futureAllocations: [JSON]) {
    self.store = config.getAscendAllocationStore()
    self.allocator = allocator
    self.previousAllocations = previousAllocations
    self.participant = participant
    self.eventEmitter = eventEmitter
    self.futureAllocations = futureAllocations
  }
  
  
  public func get<T>(key: String, defaultValue: T) {}
  
  public func subscribe<T>(key: String, defaultValue: T, AscendAction: @escaping (Any) -> Void) {
    // add some code here
  }
  
  
  public func emitEvent(key: String, score: Double) -> Void {
    self.eventEmitter.emit(key, score)
  }
  
  public func emitEvent(key: String) -> Void {
    self.eventEmitter.emit(key)
  }
  
  public func confirm() -> Void {
    let allocationStatus: Allocator.AllocationStatus = allocator.getAllocationStatus()
    if (allocationStatus == Allocator.AllocationStatus.FETCHING) {
      allocator.sandbagConfirmation()
    } else if (allocationStatus == Allocator.AllocationStatus.RETRIEVED) {
      let alloc = store.get(uid: participant.getUserId()) // can this ever be nil?
      if let allocation = alloc {
        eventEmitter.confirm(allocations: allocation)
      }
    }
  }
  
  public func contaminate() -> Void {
    let allocationStatus: Allocator.AllocationStatus = allocator.getAllocationStatus()
    if (allocationStatus == Allocator.AllocationStatus.FETCHING) {
      allocator.sandbagContamination()
    } else if (allocationStatus == Allocator.AllocationStatus.RETRIEVED) {
      let alloc = store.get(uid: participant.getUserId()) // can this ever be nil?
      if let allocation = alloc {
        eventEmitter.contaminate(allocations: allocation)
      }
    }
  }
  
}
