import Foundation
import SwiftyJSON
import PromiseKit

// EVERYTHING that is labeled Ascend in the Android SDK is what the client interacts with
class EvolvClientImpl: EvolvClientProtocol {  
  
  private let LOGGER = Log.logger
  
  private let eventEmitter: EventEmitter
  public let futureAllocations: Promise<[JSON]>? // change this back to private after presentation
  private let executionQueue: ExecutionQueue
  private let allocator: Allocator
  private let store: AllocationStoreProtocol
  private let previousAllocations: Bool
  private let participant: EvolvParticipant
  
  
  init(_ config: EvolvConfig,
       _ eventEmitter: EventEmitter,
       _ futureAllocations: Promise<[JSON]>,
       _ allocator: Allocator,
       _ previousAllocations: Bool,
       _ participant: EvolvParticipant) {
    self.store = config.getEvolvAllocationStore()
    self.executionQueue = config.getExecutionQueue()
    self.eventEmitter = eventEmitter
    self.futureAllocations = futureAllocations
    self.allocator = allocator
    self.previousAllocations = previousAllocations
    self.participant = participant
  }
  
  fileprivate func getMyType<T>(_ element: T) -> Any? {
    return type(of: element)
  }
  
  public func get<T>(key: String, defaultValue: T) -> Any {
    
    var allocations = [JSON]()
    var value = [JSON]()
    var allocationsUnpacked = false
    
    if (futureAllocations == nil) { return defaultValue }
    
    // TODO: Use the FETCHING and RECEIVED properties of Allocator to ensure this happens before moving on
    if !allocationsUnpacked {
      let _ = futureAllocations?.done { (jsonArray) in
        allocations = jsonArray
        allocationsUnpacked = true
      }
    }
    
    // You have resoved the promise to JSON
    if allocationsUnpacked {
      if !Allocator.allocationsNotEmpty(allocations: allocations) {
        return defaultValue
      }
    }

    let type = getMyType(defaultValue)
    guard let _ = type else { return defaultValue }
    do {
      let alloc = Allocations(allocations: allocations)
      let v = try alloc.getValueFromAllocations(key, type, participant)
      if let val = v { value = val }
    } catch {
      LOGGER.log(.error, message: "Unable to retrieve the treatment. Returning the default.")
      return defaultValue
    }
    return value
  }
  
  // meant to be async
  public func subscribe<T>(key: String, defaultValue: Any, function: @escaping (T) -> T) {
    let execution = Execution(key, defaultValue, function as! EvolvAction, participant)
    let previousAlloc = self.store.get(uid: self.participant.getUserId())
    if let prevAlloc = previousAlloc {
      do {
        try execution.executeWithAllocation(rawAllocations: prevAlloc)
      } catch {
        LOGGER.log(.error, message: "Unable to retrieve the value of \(key) from the allocation.")
        execution.executeWithDefault()
      }
    }
    
    let allocationStatus = allocator.getAllocationStatus()
    if allocationStatus == Allocator.AllocationStatus.FETCHING {
      // 1. enqueue the execution
      return
    } else if allocationStatus == Allocator.AllocationStatus.RETRIEVED {
      let alloc = store.get(uid: self.participant.getUserId())
      if let allocations = alloc {
        do {
          try execution.executeWithAllocation(rawAllocations: allocations)
          return
        } catch let err {
          LOGGER.log(.error, message: "Unable to retieve value from \(key), \(err.localizedDescription)")
        }
      }
    }
    execution.executeWithDefault()
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
      let alloc = store.get(uid: participant.getUserId())
      if let allocations = alloc {
        eventEmitter.confirm(allocations: allocations)
      }
    }
  }
  
  public func contaminate() -> Void {
    let allocationStatus: Allocator.AllocationStatus = allocator.getAllocationStatus()
    if (allocationStatus == Allocator.AllocationStatus.FETCHING) {
      allocator.sandbagContamination()
    } else if (allocationStatus == Allocator.AllocationStatus.RETRIEVED) {
      let alloc = store.get(uid: participant.getUserId())
      if let allocations = alloc {
        eventEmitter.contaminate(allocations: allocations)
      }
    }
  }
  
}
