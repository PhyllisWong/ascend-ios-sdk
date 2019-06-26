//
//  AscendClientImpl.swift
//  example
//
//  Created by phyllis.wong on 6/18/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit

class AscendClientImpl {
  
  private let eventEmitter: EventEmitter
  private let allocator: Allocator
  private let futureAllocations: Promise<JSON>?
  
  private let store = LRUCache.share
  
  private let previousAllocations: Bool
  private let participant: AscendParticipant
  
  init(config: AscendConfig, allocator: Allocator,
       previousAllocations: Bool, participant: AscendParticipant, eventEmitter: EventEmitter, futureAllocations: Promise<JSON>) {
   
    self.allocator = allocator
    self.previousAllocations = previousAllocations
    self.participant = participant
    self.eventEmitter = eventEmitter
    self.futureAllocations = allocator.fetchAllocations()
  }
  
  func getMyType<T>(_ element: T) -> Any? {
    return type(of: element)
  }
  
  public func get<T>(key: String, defaultValue: T) -> T {
    
    if (futureAllocations == nil) { // is this safe?
      return defaultValue
    }
    // this should be a blocking call
    let futureAllocations = allocator.fetchAllocations()
    // unpack the promise here
    let allocations = JsonArray()
    // print("JSON ALLOCATIONS: \(allocations)")
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
  
  public func subscribe<T>(key: String, defaultValue: T, function: @escaping (T) -> T) {
    let execution = Execution(key: key, defaultValue: defaultValue, function: function, participant: participant)
    let previousAlloc = self.store.get(self.participant.getUserId())
    if let prevAlloc = previousAlloc {
      do {
        try execution.executeWithAllocation(rawAllocations: prevAlloc)
      } catch {
        Log.logger.log(.error, message: "Unable to retrieve the value of \(key) from the allocation.")
        execution.executeWithDefault(defaultValue)
      }
    }
    
    let allocationStatus = allocator.getAllocationStatus()
    if allocationStatus == Allocator.AllocationStatus.FETCHING {
      // 1. enqueue the execution
      return
    } else if allocationStatus == Allocator.AllocationStatus.RETRIEVED {
        let alloc = store.get(self.participant.getUserId())
        if let allocations = alloc {
          do {
            try execution.executeWithAllocation(rawAllocations: allocations)
            return
          } catch let err {
            Log.logger.log(.error, message: "Unable to retieve value from \(key), \(err.localizedDescription)")
          }
        }
    }
    execution.executeWithDefault(defaultValue)
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
      let alloc = store.get(participant.getUserId()) // can this ever be nil?
      // let request = URLRequest(url: allocator.createAllocationsUrl())
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
