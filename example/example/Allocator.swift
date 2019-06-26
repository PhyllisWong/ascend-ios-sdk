//
//  Allocator.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

public typealias JsonArray = [JSON]?

public class Allocator {
  
  enum AllocationStatus {
    case FETCHING, RETRIEVED, FAILED
  }
  
  private let store: LRUCache
  private let config: EvolvConfig
  private let participant: EvolvParticipant
  private let httpClient: HttpClient
  private let eventEmitter: EventEmitter
  
  private var confirmationSandbagged: Bool = false
  private var contaminationSandbagged: Bool = false
  private var logger: Logger
  private var allocationStatus: AllocationStatus
  // private var allocationFuture: Promise<JSON>
  
  init(
       config: EvolvConfig,
       participant: EvolvParticipant) {
    self.store = LRUCache.share
    self.config = config
    self.participant = participant
    self.httpClient = HttpClient()
    self.allocationStatus = AllocationStatus.FETCHING
    self.logger = Log.logger
    // self.allocationFuture = Allocator.fetchAllocations()
    // self.executionDispatch = executionDispatch
    self.eventEmitter = EventEmitter(config: config, participant: participant)
  }
  
  func getAllocationStatus() -> AllocationStatus { return allocationStatus }
  func sandbagConfirmation() -> () { confirmationSandbagged = true }
  func sandbagContamination() -> () { contaminationSandbagged = true }
  
  
  public func createAllocationsUrl() -> URL {
    var components = URLComponents()
    components.scheme = config.getHttpScheme()
    components.host = config.getDomain()
    components.path = "/\(config.getVersion())/\(config.getEnvironmentId())/allocations"
    components.queryItems = [
      URLQueryItem(name: "uid", value: "\(participant.getUserId())")
    ]
    
    if let url = components.url { return url }
    return URL(string: "")!
  }
  
  public typealias JsonArray = [JSON]
  
  public func fetchAllocations() -> Promise<[JSON]> {
    
    return Promise { resolve in
      let url = self.createAllocationsUrl()
 
      let strPromise = HttpClient.get(url: url).done { (stringJSON) in
        var allocationsArray = JSON.init(parseJSON: stringJSON).arrayValue
        print(allocationsArray[0]["eid"])
        let previous = self.store.get(self.participant.getUserId())
        if let prevAlloc = previous {
          if Allocator.allocationsNotEmpty(allocations: prevAlloc) {
            allocationsArray = Allocations.reconcileAllocations(previousAllocations: prevAlloc, currentAllocations: allocationsArray)
          }
        }
        
        self.store.set(self.participant.getUserId(), val: allocationsArray)
        self.allocationStatus = AllocationStatus.RETRIEVED
        
        if (self.confirmationSandbagged) {
          self.eventEmitter.confirm(allocations: allocationsArray)
        }
        
        if self.contaminationSandbagged {
          self.eventEmitter.contaminate(allocations: allocationsArray)
        }
        // execute with all values
        resolve.fulfill(allocationsArray)
      }
    }
  }

  static func allocationsNotEmpty(allocations: [JSON]?) -> Bool {
    guard let allocArray = allocations else {
      return false
    }
    return allocArray.count > 0
  }
  
}

