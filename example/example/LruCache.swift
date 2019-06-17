//
//  LruCache.swift
//  example
//
//  Created by phyllis.wong on 6/14/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

//struct LruCache {
//  static let store = LruCache()
extension URLCache {
  
  func getEntry(url: URL) -> Data {
    var cachedResponse = CachedURLResponse()
    let session = URLSession.shared.dataTask(with: url)
    let data = Data()
    URLCache.shared.getCachedResponse(for: session, completionHandler: { (cachedData) in
      if let cached = cachedData {
        print("Cached Response: \(cached)")
        cachedResponse = cached
      }
    })
    return data
  }
  
  func putEntry(){}
}

