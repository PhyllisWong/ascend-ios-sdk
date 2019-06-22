//
//  Allocator.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import DynamicJSON
import Alamofire

public typealias JsonArray = [[String: Any]]?

public class Allocator {
  
  enum AllocationStatus {
    case FETCHING, RETRIEVED, FAILED
  }
  
  private let store: LRUCache<String>
  private let config: AscendConfig
  private let participant: AscendParticipant
  private let httpClient: HttpClient
  // private let eventEmitter: EventEmitter
  
  private var confirmationSandbagged: Bool = false
  private var contaminationSandbagged: Bool = false
  private var logger: Logger
  private var allocationStatus: AllocationStatus
  
  init(
       store: LRUCache<String>,
       config: AscendConfig,
       participant: AscendParticipant,
       httpClient: HttpClient
       // eventEmitter: EventEmitter,
       // executionDispatch: ExecutionDispatch
    ) {
    self.store = LRUCache(10)
    self.config = config
    self.participant = participant
    self.httpClient = httpClient
    self.allocationStatus = AllocationStatus.FETCHING
    self.logger = Log.logger
    // self.executionDispatch = executionDispatch
    // self.eventEmitter = eventEmitter
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
  
  public func fetchAllocations() -> [Dictionary<String, Any>] {
    let url = self.createAllocationsUrl()
    let stringUrl = String(describing: url)
    // let url = URL(string: "kjnsdfjbn")! // BAD!!!! for testing
    var jsonArray = [Dictionary<String, Any>]()
    var previousAllocations = [JSON]()
    
    let semaphore = DispatchSemaphore(value: 0)
    let cached = store.get(stringUrl) as! [JSON]?
    if let cachedAlloc = cached {
      // you have some previous stuff here
      previousAllocations = cachedAlloc
      print("Previous allocations: \(String(describing: previousAllocations))")
    } else {
      // IT HITS HERE EACH TIME
      print("Error getting previous allocations")
    }
    
    NetworkingService.sharedInstance.get(fromUrl: url, completion: { (_data, res, err) in
      if let error = err {
        self.logger.log(.debug, message: "Error : \(error.localizedDescription)")
      }
      guard let response = res, let data = _data else {
        self.logger.log(.debug, message: "NetworkingError data")
        return
      }
      
      if let jsonArr = try? JSONSerialization.jsonObject(with: data, options: []) as? [Dictionary<String,Any>]  {
        print("RESPONSE: \(jsonArr)")
        if let gnomes = jsonArr[0]["genome"] {
          print(gnomes)
        }
        jsonArray = jsonArr
      }
      // print("RESPONSE: \(json)")
      
      
      self.store.set(stringUrl, val: data)
      let cached = self.store.get(stringUrl)
      
      print("Cached: \(JSON(cached!))")
      // previousAllocations = [JSON(cached as! Data)]
      semaphore.signal()
    })
    _ = semaphore.wait(timeout: .distantFuture)
    
//    if previousAllocations.count > 0 {
//      jsonArray = previousAllocations
//    }
    return jsonArray
  }

  func allocationsNotEmpty(allocations: [JSON]?) -> Bool {
    guard let allocationsArray = allocations else {
      return false
    }
    return allocationsArray.count > 0
  }
  
}

