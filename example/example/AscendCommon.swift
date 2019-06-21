//
//  AscendCommon.swift
//  example
//
//  Created by phyllis.wong on 6/17/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

///The allocation key is a String. This typealias helps define where the SDK expects the string to be an allocation key.
public typealias AscendAllocationKey = String

///An object can own an observer for as long as the object exists. Swift structs and enums cannot be observer owners.
public typealias AscendObserverOwner = AnyObject
///A closure used to notify an observer owner of a change to a single allocation's value.
public typealias AscendAllocationChangeHandler = (Allocations) -> Void
///A closure used to notify an observer owner of a change to the allocation in a collection of `AscendChangedAllocations`.
public typealias AscendAllocationCollectionChangeHandler = ([AscendAllocationKey: AscendChangedAllocation]) -> Void
///A closure used to notify an observer owner that a allocation request resulted in no changes to any allocation.
public typealias AscendAllocationsUnchangedHandler = () -> Void
///A closure used to notify an observer owner that an error occurred during allocation processing.
public typealias AscendErrorHandler = (Error) -> Void

extension AscendAllocationKey {
  private static var anyKeyIdentifier: AscendAllocationKey {
    return "Ascend.AllocationKeyList.Any"
  }
  static var anyKey: [AscendAllocationKey] {
    return [anyKeyIdentifier]
  }
}

public struct AscendChangedAllocation {
  ///The key of the changed
  public let key: AscendAllocationKey
  ///The allocation's value before the change. The client app will have to convert the oldValue into the expected type.
  public let oldValue: Any?
  ///The allocation's value after the change. The client app will have to convert the newValue into the expected type.
  public let newValue: Any?
  
  init(key: AscendAllocationKey, oldValue: Any?, newValue: Any?) {
    self.key = key
    self.oldValue = oldValue
    self.newValue = newValue
  }
}
