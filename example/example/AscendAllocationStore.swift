//
//  AscendAllocationStore.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

// This is the inerface for the client
public protocol AscendAllocationStore {
  
  /**
   * Retrieves a JsonArray.
   * <p>
   *     Retrieves a JsonArray that represents the participant's allocations.
   *     If there are no stored allocations, should return an empty JsonArray.
   * </p>
   * @param uid the participant's unique id
   * @return an allocation if one exists else an empty JsonArray
   */
  
  // What data type this supposed to return, and will it need to be serialized to json?
  static func getJsonArray(uid: String) -> [[String: Any]?]
  
  /**
   * Stores a JsonArray.
   * <p>
   *     Stores the given JsonArray.
   * </p>
   * @param uid the participant's unique id
   * @param allocations the participant's allocations
   */
  
  // Do we want to go some kind of confirmation that this was sucessful?
  // Where are we storing this data?
  static func putJsonArray(uid: String, jsonArray: [[String: Any]]) -> ()
}
