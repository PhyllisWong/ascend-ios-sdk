//
//  AscendClientImpl.swift
//  example
//
//  Created by phyllis.wong on 6/18/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import SwiftyJSON

class AscendClientImpl : AscendClient {
  
  private let eventEmitter: EventEmitter
  private let allocator: Allocator
  private let futureAllocations: [JSON]?
  
  let store = LRUCache(10)
  
  private let previousAllocations: Bool
  private let participant: AscendParticipant
  
  init(config: AscendConfig, allocator: Allocator,
       previousAllocations: Bool, participant: AscendParticipant, eventEmitter: EventEmitter, futureAllocations: [JSON]) {
   
    self.allocator = allocator
    self.previousAllocations = previousAllocations
    self.participant = participant
    self.eventEmitter = eventEmitter
    self.futureAllocations = Allocator.fetchAllocations(self.allocator)()
  }
  
  func getMyType<T>(_ element: T) -> Any? {
    return type(of: element)
  }
  
  public func get<T>(key: String, defaultValue: T) -> T {
    
    if (futureAllocations == nil) { // is this safe?
      return defaultValue
    }
    // this should be a blocking call
    let allocations = "[{\"audience_query\":\"<null>\",\"cid\":\"1cc385bf3757:9b0e33b869\",\"eid\":\"9b0e33b869\",\"excluded\":\"0\",\"genome\": {\"background\": {\"height\": 90, \"width\": \"0.5\"}, \"button\": \"yellow\"}, \"uid\": \"1AEA8FDC-42B4-4737-8267-4E1B851C2BB4\"}]"
    
    print("JSON ALLOCATIONS: \(allocations)")
    store.set(key, val: allocations)
    let storedAlloc = store.get(key)
    print("STORED ALLOCATIONS: \(String(describing: storedAlloc))")
    if (!Allocator.allocationsNotEmpty(allocations: allocations)) {
      return allocations as! T
    }
    // let type = getMyType(element)
    // let value = Allocations(allocations: allocations).getValueFromAllocations(key, type, participant)
    
    return defaultValue
  }
  
  public func subscribe<T>(key: String, defaultValue: T, AscendAction: @escaping (Any) -> Void) {
    // 1. initialize an execution queue
    // 2. check for previous allocations
    // 3. if there are previous allocations, get allocations from the store
    // 4. executeWithAllocations(allocations) cached allocations
    // 5.a if there was an error, log error ("Unable to retrieve the value of %s from the allocation.")
    // 5.b execute with default
    // 6.a if there is an error executing with default
    // 6.b log this error: "There was an error when applying the stored treatment."
    let allocationStatus: Allocator.AllocationStatus = allocator.getAllocationStatus()
    if allocationStatus == Allocator.AllocationStatus.FETCHING {
      // 1. enqueue the execution
      // 2. return (you are done)
    } else if allocationStatus == Allocator.AllocationStatus.RETRIEVED {
      let allocations: Any = store.get(participant.getUserId()) as Any // safly unwrap this value
      // 1. executeWithAllocations(allocations) cached allocations
      // 2. return (you are done)
      // 3.a check for errors
//      LOGGER.debug(String.format("Unable to retrieve" +
//        " the value of %s from the allocation.",  execution.getKey()), e);
      // LOGGER.error("There was an error applying the subscribed method.", e);
    }
    // execution.executeWithDefault()
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
      // let alloc = store.get(uid: participant.getUserId()) // can this ever be nil?
      // let request = URLRequest(url: allocator.createAllocationsUrl())
      let alloc = store.get(participant.getUserId())
      if let allocation = alloc {
        eventEmitter.confirm(allocation)
      }
    }
  }
  
  public func contaminate() -> Void {
    let allocationStatus: Allocator.AllocationStatus = allocator.getAllocationStatus()
    if (allocationStatus == Allocator.AllocationStatus.FETCHING) {
      allocator.sandbagContamination()
    } else if (allocationStatus == Allocator.AllocationStatus.RETRIEVED) {
      let alloc = store.get(participant.getUserId()) // can this ever be nil?
//      let request = URLRequest(url: allocator.createAllocationsUrl())
//      let alloc = store.cachedResponse(for: request)
      if let allocation = alloc {
        eventEmitter.contaminate(allocations: allocation)
      }
    }
  }
  
}
