//
//  Allocator.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import DynamicJSON

public typealias JsonArray = [[String: Any]]?

public class Allocator {
  
  enum AllocationStatus {
    case FETCHING, RETRIEVED, FAILED
  }
  
  // private let executionDispatch: ExecutionDispatch
  // private let store: AscendAllocationStore // TODO: in memory store
  private let config: AscendConfig
  private let participant: AscendParticipant
  // private let eventEmitter: EventEmitter
  private let httpClient: HttpClient
  
  private var confirmationSandbagged: Bool = false
  private var contaminationSandbagged: Bool = false
  
  private var allocationStatus: AllocationStatus
  
  init(//executionDispatch: ExecutionDispatch,
       //store: AscendAllocationStore,
       config: AscendConfig,
       participant: AscendParticipant,
       // eventEmitter: EventEmitter,
       httpClient: HttpClient
    ) {
    // self.executionDispatch = executionDispatch
    // self.store = store
    self.config = config
    self.participant = participant
    // self.eventEmitter = eventEmitter
    self.httpClient = httpClient
    self.allocationStatus = AllocationStatus.FETCHING
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
  
  public func fetchAllocations(url: URL) -> JsonArray {
    let fakeJsonArray = [["height": 0.90, "button": "blue"]]
    
    HttpClient.get(url: url, completion: { (response) in
      guard let response = response else { // response needs to be safe unwrapped
        print("OOPS!")
        return
      }
      // let really_bad_var_name = response // as! Dictionary<String, [Dictionary<String, Any>]>
      let json = JSON(response) // as! Dictionary<String, String>
      print(json) // TODO: save this is the store
    })
    
    return fakeJsonArray
  }
  
  public func resolveAllocationsFailure() -> JsonArray {
    let fakeJsonArray = [["height": 0.90, "button": "blue"]]
    
    return fakeJsonArray
  }
  
  static func allocationsNotEmpty(allocations: JsonArray) -> Bool {
    
    if let allocations = allocations {
      if allocations.count > 0 { return true }
    }
    return false
  }
  
}

