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
  private let dispatchGroup = DispatchGroup()
  
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
    var value = [JSON]()
    var promisedAllocations = [JSON]()
    // let dq = DispatchQueue(label: "futureAllocations")
    let cachedData = store.get(uid: participant.getUserId())
    print("Cached data from client.get() \(cachedData)")
    if (futureAllocations == nil) {
      print("\(String(describing: futureAllocations))")
      return defaultValue
    }

    do {
      let a = try futureAllocations?.wait()
      guard let alloc = a else {
        return defaultValue
      }
      
      promisedAllocations = alloc
      if !Allocator.allocationsNotEmpty(allocations: promisedAllocations) {
        return defaultValue
      }
      
      let type = getMyType(defaultValue)
      guard let _ = type else { return defaultValue }
      do {
        let alloc = Allocations(allocations: promisedAllocations)
        let v = try alloc.getValueFromAllocations(key, type, participant)
        value = [v] as! [JSON]
      } catch {
        LOGGER.log(.error, message: "Unable to retrieve the treatment. Returning the default.")
        return defaultValue
      }
    } catch {
      LOGGER.log(.debug, message: "Error retrieving Allocations")
    }
    
    // Check that the allocations has a value
    return value
  }
  
  // meant to be async
  public func subscribe<T>(key: String, defaultValue: Any, function: @escaping (T) -> T) {
    let execution = Execution(key, defaultValue, function as! EvolvAction, participant)
    let previousAlloc = self.store.get(uid: self.participant.getUserId())
    if let prevAlloc = previousAlloc {
      let prevJSON = [JSON(prevAlloc)]
      do {
        try execution.executeWithAllocation(rawAllocations: prevJSON)
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
      let allocStr = store.get(uid: self.participant.getUserId())
      let alloc = [JSON(allocStr)]
     
        do {
          try execution.executeWithAllocation(rawAllocations: alloc)
          return
        } catch let err {
          LOGGER.log(.error, message: "Unable to retieve value from \(key), \(err.localizedDescription)")
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
