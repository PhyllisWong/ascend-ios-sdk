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
  
  let store = URLCache.shared // TODO: change this with abstracted class
  private let config: AscendConfig
  private let participant: AscendParticipant
  // private let eventEmitter: EventEmitter
  private let httpClient: HttpClient
  
  private var confirmationSandbagged: Bool = false
  private var contaminationSandbagged: Bool = false
  private var logger: Logger
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
    self.logger = Log.logger
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
  
  public func fetchAllocations() -> JSON {
    let url = self.createAllocationsUrl()
    // let url = URL(string: "kjnsdfjbn")! // BAD!!!! for testing
    var jsonArray = JSON()
    var cachedResponse = CachedURLResponse()
    let semaphore = DispatchSemaphore(value: 0)
    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
    let session = URLSession.shared.dataTask(with: url)
    
    do {
      let cached = try LruCache.sharedInstance.getEntry(store: self.store, session: session)
      if let c = cached {
        cachedResponse = c
      }
    } catch {
        print("Error retrieving cached allocation")
    }
      NetworkingService.sharedInstance.get(fromUrl: url, completion: { (_data, res, err) in
        if let error = err {
          self.logger.log(.debug, message: "Error : \(error.localizedDescription)")
        }
        guard let response = res, let data = _data else {
          self.logger.log(.debug, message: "NetworkingError data")
          return
        }

        jsonArray = JSON(data)

        do {
          let _ = try LruCache.sharedInstance.putEntry(store: self.store, request: request, response: response, data: data)
        } catch {
          self.logger.log(.debug, message: "Error saving to the cache")
        }
        semaphore.signal()
      })
      _ = semaphore.wait(timeout: .distantFuture)
      
      // TODO: add reconciliation logic here
      if (JSON(cachedResponse.data) == jsonArray) {
        return JSON(cachedResponse.data)
      }
    return jsonArray
  }
  
  
  public func resolveAllocationsFailure(session: URLSessionDataTask) -> [JSON] {
    var previousAllocations = [JSON]()
    
    let semaphore = DispatchSemaphore(value: 0)
    self.store.getCachedResponse(for: session, completionHandler: { (cachedData) in
      if let cached = cachedData {
        print("Cached Response: \(cached)")
        previousAllocations = [JSON(cached)]
      }
      semaphore.signal() // tell the semaphore that we are done
    })
     _ = semaphore.wait(timeout: .distantFuture)
    
    if (allocationsNotEmpty(allocations: previousAllocations)) {
      logger.log(.debug, message: "Falling back to participant's previous allocation.")
    }
    return previousAllocations
  }
  
  func allocationsNotEmpty(allocations: [JSON]?) -> Bool {
    guard let allocationsArray = allocations else {
      return false
    }
    return allocationsArray.count > 0
  }
  
}

