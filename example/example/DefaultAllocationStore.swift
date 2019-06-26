//
//  DefaultAllocationStore.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import SwiftyJSON

public class DefaultAllocationStore : AscendAllocationStore {
  public func get(uid: String) -> String? {
    let fakeCache = "[[\"key\": \"value\"]]"
    //    return cache.getEntry(uid);
    print("FAKE CACHE VALUE: \(fakeCache)")
    return fakeCache
  }
  
  public func put(uid: String, allocations: String) {
    let fakeCache: String = "[[\"Key\": [\"otherKey\": \"value\"]]]"
        print("FAKE CACHE JSON: \(fakeCache)")
  }
  
//  public func getEntry(store: URLCache, session: URLSessionDataTask) throws -> CachedURLResponse? {
//    let fakeCache = "[[\"key\": \"value\"]]" as! CachedURLResponse
//    //    return cache.getEntry(uid);
//    print("FAKE CACHE VALUE: \(fakeCache)")
//    return fakeCache
//  }
//
//  public func putEntry(store: URLCache, request: URLRequest, response: URLResponse, data: Data) throws {
//    let fakeCache: String = "[[\"Key\": [\"otherKey\": \"value\"]]]"
//    print("FAKE CACHE JSON: \(fakeCache)")
//  }

  
//  private LruCache cache;
  init(size: Int) {
  }

}
