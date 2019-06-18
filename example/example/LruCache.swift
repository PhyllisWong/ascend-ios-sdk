//
//  LruCache.swift
//  example
//
//  Created by phyllis.wong on 6/14/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

struct LruCache {
  static let sharedInstance = LruCache()
// extension URLCache {
  
  func getEntry(store: URLCache, session: URLSessionDataTask) throws -> CachedURLResponse? {
    var cachedResponse = CachedURLResponse()
    store.getCachedResponse(for: session, completionHandler: { (cachedData) in
      if let cached = cachedData {
        cachedResponse = cached
      }
    })
    return cachedResponse
  }
  
  func putEntry(store: URLCache, request: URLRequest, response: URLResponse, data: Data) throws -> Void {
    let cachedURLResponse = CachedURLResponse(response: response, data: data, userInfo: nil, storagePolicy: .allowedInMemoryOnly)
    store.storeCachedResponse(cachedURLResponse, for: request)
  }
}

