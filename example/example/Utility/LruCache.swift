//
//  LruCache.swift
//  example
//
//  Created by phyllis.wong on 6/14/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

public class LRUCache {
  
  
  static var maxSize: Int = 10
  private var cache: [String: Any] = [:]
  private var priority: LinkedList<String> = LinkedList<String>()
  private var key2node: [String: LinkedList<String>.LinkedListNode<String>] = [:]
  
  static let share = LRUCache(maxSize)
  public init(_ maxSize: Int = 10) {
    // LRUCache.maxSize = maxSize
  }
  
  public func get(_ key: String) -> Any? {
    guard let val = cache[key] else {
      return nil
    }
    
    remove(key)
    insert(key, val: val)
    
    return val
  }
  
  public func set(_ key: String, val: Any) {
    if cache[key] != nil {
      remove(key)
    } else if priority.count >= LRUCache.maxSize, let keyToRemove = priority.last?.value {
      remove(keyToRemove)
    }
    
    insert(key, val: val)
  }
  
  private func remove(_ key: String) {
    cache.removeValue(forKey: key)
    guard let node = key2node[key] else {
      return
    }
    priority.remove(node: node)
    key2node.removeValue(forKey: key)
  }
  
  private func insert(_ key: String, val: Any) {
    cache[key] = val
    priority.insert(key, atIndex: 0)
    guard let first = priority.first else {
      return
    }
    key2node[key] = first
  }
}
