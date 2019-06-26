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
  private let config: AscendConfig
  private let participant: AscendParticipant
  private let httpClient: HttpClient
  private let eventEmitter: EventEmitter
  
  private var confirmationSandbagged: Bool = false
  private var contaminationSandbagged: Bool = false
  private var logger: Logger
  private var allocationStatus: AllocationStatus
  // private var allocationFuture: Any?
  
  init(
       config: AscendConfig,
       participant: AscendParticipant) {
    self.store = LRUCache(10)
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
  public func fetchAllocations() -> [JSON] {
    let url = self.createAllocationsUrl()
    let stringUrl = String(describing: url)
    let cacheUrl = URL(string: "kjnsdfjbn")! // BAD!!!! for testing
    var jsonArray = [JSON]()
    let previousAllocations = [JSON]()
    let apiService = HttpClient()
    let futuresAllocations = HttpClient.get(url: url)

    
    if previousAllocations.count > 0 {
      jsonArray = previousAllocations
    }
    let cachedJsonArray = self.store.get(self.config.getEnvironmentId()) as? [JSON]
    if let cached = cachedJsonArray {
      jsonArray = cached
    }
    return jsonArray
  }

  static func allocationsNotEmpty(allocations: JsonArray?) -> Bool {
    guard let allocationsArray = allocations else {
      return false
    }
    return allocationsArray.count > 0
  }
  
}

