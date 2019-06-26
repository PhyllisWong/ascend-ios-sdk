//
//  EvolvCommon.swift
//  example
//
//  Created by phyllis.wong on 6/17/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

///The allocation key is a String. This typealias helps define where the SDK expects the string to be an allocation key.
public typealias EvolvAllocationKey = String

///An object can own an observer for as long as the object exists. Swift structs and enums cannot be observer owners.
public typealias EvolvObserverOwner = AnyObject
///A closure used to notify an observer owner of a change to a single allocation's value.
public typealias EvolvAllocationChangeHandler = (Allocations) -> Void
///A closure used to notify an observer owner of a change to the allocation in a collection of `EvolvChangedAllocations`.
public typealias EvolvAllocationCollectionChangeHandler = ([EvolvAllocationKey: EvolvChangedAllocation]) -> Void
///A closure used to notify an observer owner that a allocation request resulted in no changes to any allocation.
public typealias EvolvAllocationsUnchangedHandler = () -> Void
///A closure used to notify an observer owner that an error occurred during allocation processing.
public typealias EvolvErrorHandler = (Error) -> Void

extension EvolvAllocationKey {
  private static var anyKeyIdentifier: EvolvAllocationKey {
    return "Evolv.AllocationKeyList.Any"
  }
  static var anyKey: [EvolvAllocationKey] {
    return [anyKeyIdentifier]
  }
}

public struct EvolvChangedAllocation {
  ///The key of the changed
  public let key: EvolvAllocationKey
  ///The allocation's value before the change. The client app will have to convert the oldValue into the expected type.
  public let oldValue: Any?
  ///The allocation's value after the change. The client app will have to convert the newValue into the expected type.
  public let newValue: Any?
  
  init(key: EvolvAllocationKey, oldValue: Any?, newValue: Any?) {
    self.key = key
    self.oldValue = oldValue
    self.newValue = newValue
  }
}
