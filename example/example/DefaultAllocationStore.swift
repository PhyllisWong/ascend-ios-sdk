//
//  DefaultAllocationStore.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import SwiftyJSON

public class DefaultAllocationStore : AllocationStoreProtocol {
  private var cache: LRUCache
  
  init(size: Int) {
    self.cache = LRUCache(size)
  }
  public func get(uid: String) -> [JSON]? {
    return cache.get(uid)
  }
  
  public func set(uid: String, allocations: [JSON]) {
    cache.set(uid, val: allocations)
  }
}
