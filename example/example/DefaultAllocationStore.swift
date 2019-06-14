//
//  DefaultAllocationStore.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import Track

public class DefaultAllocationStore : AscendAllocationStore {

  
//  private LruCache cache;
  
  init(size: Int) {
//    this.cache = new LruCache(size);
  // TODO: figure out the cache situation
  }

  public func get(uid: String) -> [[String : Any]?] {
    let fakeCache = [["key": "value"]]
    //    return cache.getEntry(uid);
    return fakeCache
  }
  
  public func put(uid: String, allocations: [[String: Any]]) {
//    cache.putEntry(uid, allocations);
    let fakeCache = [["Key": ["otherKey": "value"]]]
  }
}
