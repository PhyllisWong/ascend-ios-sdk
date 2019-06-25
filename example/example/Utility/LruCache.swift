//
//  LruCache.swift
//  example
//
//  Created by phyllis.wong on 6/14/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

public protocol AllocationsStore {
  func get<T>(_ key: String) -> T?
  func set<T>(_ key: String, val: T)
}

public class LRUCache: AllocationsStore {

  
  static var maxSize: Int = 10
  private var cache = [String: AnyObject]()
  private var priority: LinkedList<String> = LinkedList<String>()
  private var key2node: [String: LinkedList<String>.LinkedListNode<String>] = [:]
  
  static let share = LRUCache(maxSize)
  
  public init(_ maxSize: Int = 10) {}
  
  public func get<T>(_ key: String) -> T? {
    guard let val = cache[key] else {
      return nil
    }
    remove(key)
    insert(key, val: val)
    return (val as! T)
  }
  
  public func set<T>(_ key: String, val: T) {
    if cache[key] != nil {
      remove(key)
    } else if priority.count >= LRUCache.maxSize, let keyToRemove = priority.last?.value {
      remove(keyToRemove)
    }
    insert(key, val: T.self)
  }
  
  private func remove(_ key: String) {
    cache.removeValue(forKey: key)
    guard let node = key2node[key] else {
      return
    }
    priority.remove(node: node)
    key2node.removeValue(forKey: key)
  }
  
  private func insert<T>(_ key: String, val: T) {
    cache[key] = val as AnyObject
    priority.insert(key, atIndex: 0)
    guard let first = priority.first else {
      return
    }
    key2node[key] = first
  }
}


//class LocalMemoryAllocationStoreImpl: AllocationsStore {
////  private var allocations: JSON? = nil
////  private var eid: String = ""
//  private var cachedAllocation: (json: JSON, eid: Int)?
//
//  func store(json: JSON, for eid: String) -> Promise<Void> {
//    return Guarantee {
//      guard eid != self.cachedAllocation.eid else { return }
//      self.cachedAllocation = (json, eid)
//    }
//  }
//
//  func loadStoredAllocationJSON() -> Promise<(json: JSON, eid: Int)> {
//    return Guarantee {
//      guard let allocations = self.cachedAllocation else { return nil }
//      return (allocations.json, allocations.eid)
//    }
//  }
//}
