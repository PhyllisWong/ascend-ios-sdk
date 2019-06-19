//
//  DefaultAllocationStore.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import DynamicJSON

public class DefaultAllocationStore : AscendAllocationStore {
  public func get(uid: String) -> [JSON]? {
    let fakeCache = [["key": "value"]] as [JSON]
    //    return cache.getEntry(uid);
    print("FAKE CACHE VALUE: \(fakeCache)")
    return fakeCache
  }
  
  public func put(uid: String, allocations: [JSON]) {
    let fakeCache = [["Key": ["otherKey": "value"]]] as [JSON]
    print("FAKE CACHE JSON: \(fakeCache)")
  }
  
//  private LruCache cache;
  
  init(size: Int) {
//    this.cache = new LruCache(size);
  // TODO: figure out the cache situation
  }

}
