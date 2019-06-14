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
  
  public func fetchAllocations() -> JSON {
//    var fakeJsonArray: JSON = [["height": 0.90, "button": "blue"]]
    let url = self.createAllocationsUrl()
    /*
     1. create the URL
     2. create the allocationFuture (settable)
     3. sets an observable (some way to know when the promise os returned)
     4. instantiate a JSON parser
     5. parse the JSON returned by the future
     6. get previous allocation from the store
     7. reconcile the allocations (are they the same, different, is the previous allocation valid?
     8. save allocation to the store (this updates the cache date if alloc the same)
     9. update the allocation status
     10. emit some event
     11. set the allocationFuture with returned allocations
     12. executeQueue should execute all values from the allocation
     13. catch and handle error, set allocationFuture with resolveAllocationFailure
     14. return allocationFuture (will either have allocations or an error
     */

    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
    var fakeJsonArray = JSON()
    
    
    
    Alamofire.request(request).responseJSON { (response) in
      let cachedURLResponse = CachedURLResponse(response: response.response!, data: (response.data! as NSData) as Data, userInfo: nil, storagePolicy: .allowed)
      URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
      guard response.result.error == nil else {
        print("error fetching data from url")
        print(response.result.error!)
        return
      }
      
      let json = try? JSON(data: cachedURLResponse.data) // SwiftyJSON
      // do whatever you want with your data here
     
      fakeJsonArray = json!
      // return fakeJsonArray
      print("stuff: \(json!)")
      
    }
    
    
    print("Your json: \(String(describing: fakeJsonArray))") // Test if it works
    return fakeJsonArray
  }
  enum NetworkError: Error {
    case url
  }
//
//  func fetchAllocationsAsyncAwait() throws -> Data? {
//    let dummyURL = createAllocationsUrl()
//    if dummyURL {
//      throw NetworkError.url
//    }
//  }
  
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

