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

public class Allocator {
  
  enum AllocationStatus {
    case FETCHING, RETRIEVED, FAILED
  }
  
  private let store: LRUCache
  private let config: AscendConfig
  private let participant: AscendParticipant
  private let httpClient: HttpProtocol
  private let eventEmitter: EventEmitter
  private var allocationStatus: AllocationStatus
  
  private var confirmationSandbagged: Bool = false
  private var contaminationSandbagged: Bool = false
  private var logger: Logger
  
  init(
       config: AscendConfig,
       participant: AscendParticipant,
       httpClient: HttpProtocol) {
    self.store = LRUCache(10)
    self.config = config
    self.participant = participant
    self.httpClient = httpClient
    self.allocationStatus = AllocationStatus.FETCHING
    self.logger = Log.logger
    // self.executionDispatch = executionDispatch
    self.eventEmitter = EventEmitter(config: config, participant: participant)
  }
  
  func getAllocationStatus() -> AllocationStatus { return allocationStatus }
  func sandbagConfirmation() -> () { confirmationSandbagged = true }
  func sandbagContamination() -> () { contaminationSandbagged = true }
  
  
  func createAllocationsUrl() -> URL {
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
  
  public func fetchAllocations() -> Promise<JSON> {
    let url: URL = createAllocationsUrl()
    var allocations = JsonArray()
    
    let responsePromise = httpClient.get(url).done { (fetchedJSON) in
      let fetchedAlloc: JsonArray = JSON(fetchedJSON).array ?? []
      if fetchedAlloc.count > 0 {
        
        let previousAlloc = self.store.get(self.participant.getUserId())
        
        if let previousAllocations = previousAlloc {
          if previousAllocations.count > 0 {
            allocations = Allocations.reconcileAllocations(previousAllocations, allocations)
          }
        }
        self.store.set(self.participant.getUserId(), val: allocations)
        self.allocationStatus = AllocationStatus.RETRIEVED
        
        if self.confirmationSandbagged {
          self.eventEmitter.confirm(allocations)
        }
      }
    }
    return responsePromise
  }

  static func allocationsNotEmpty(allocations: JsonArray?) -> Bool {
    guard let allocationsArray = allocations else {
      return false
    }
    return allocationsArray.count > 0
  }
  
}

