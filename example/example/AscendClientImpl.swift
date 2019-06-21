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
  private let futureAllocations: [JSON]?
  private let logger = Log.logger
  private let allocator: Allocator
  // FIXME: the cache does not work
  // private let store: AscendAllocationStore
  private let previousAllocations: Bool
  private let participant: AscendParticipant
  
  init(config: AscendConfig, allocator: Allocator,
       previousAllocations: Bool, participant: AscendParticipant,
       eventEmitter: EventEmitter, futureAllocations: [JSON]) {
    // self.store = config.getAscendAllocationStore()
    self.allocator = allocator
    self.previousAllocations = previousAllocations
    self.participant = participant
    self.eventEmitter = eventEmitter
    self.futureAllocations = futureAllocations
  }
  
  func getMyType<T>(_ element: T) -> Any? {
    return type(of: element)
  }
  
  public func get<T>(key: String, defaultValue: T) -> T {
    
    if (futureAllocations == nil) { // is this safe?
      return defaultValue
    }
    // this should be a blocking call
    // let allocations: [JSON] = [allocator.fetchAllocations()]
    let allocations = "[{\"audience_query\":\"<null>\",\"cid\":\"1cc385bf3757:9b0e33b869\",\"eid\":\"9b0e33b869\",\"excluded\":\"0\",\"genome\": {\"background\": {\"height\": 90, \"width\": \"0.5\"}, \"button\": \"yellow\"}, \"uid\": \"1AEA8FDC-42B4-4737-8267-4E1B851C2BB4\"}]"
    let jsonAlloc = [JSON(allocations)]
    print("JSON ALLOCATIONS: \(jsonAlloc)")
    if (!allocator.allocationsNotEmpty(allocations: jsonAlloc)) {
      return defaultValue
    }
    // let type = getMyType(element)
    // let value = Allocations(allocations: allocations).getValueFromAllocations(key, type, participant)
    
    return defaultValue
  }
  
  public func subscribe<T>(key: String, defaultValue: T, AscendAction: @escaping (Any) -> Void) {
    
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
