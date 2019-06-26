//
//  Allocations.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Allocations {
  let allocations: JsonArray
  let audience : Audience = Audience()
  
  init (allocations: JsonArray) {
    self.allocations = allocations
  }
  
  func getMyType<T>(_ element: T) -> Any? {
    return type(of: element)
  }
  

  typealias JsonElement = Any
  
  // func getValueFromAllocations<T>(key: String, type: T, participant: AscendParticipant) throws -> T {
  func getValueFromAllocations<T>(key: String, type: T, participant: AscendParticipant) throws -> Dictionary<String,Any> {
    var dict = [String: Any]()
    var keyParts = [String]()
    var allocation = [String: Any]()
    
    // iterate through the array of json
    for alloc in allocations {
      for (k, v) in alloc {
         // convert each item into a swift dict
        dict[k] = v.stringValue
      }
    }
    do {
      keyParts = key.components(separatedBy: "\\.")
      if (keyParts.isEmpty()) { throw AscendKeyError(rawValue: "Key provided was empty.")! }
      
      // check to see if there is an audience filter
      // if not... traverse the genome object and get the value at each key part
      // return new jsonObj with the element and type
      
      let keyPartsStr = keyParts.map{ String($0) }
      let eid = allocation["eid"]
      Log.logger.log(.debug, message: "Unable to find key \(keyPartsStr) in experiement \(String(describing: eid))")
      
    } catch let error {
      Log.logger.log(.debug, message: "Key provided was empty.")
      return ["":""]
    }
    return  ["":""]
  }
  
  func getElementFromGenome(genome: Any, keyParts: [String]) throws -> Any {
    var element: JsonElement? = genome
    if element == nil { // is this a safe check?
      throw AscendKeyError(rawValue: "Allocation genome was empty")!
    }
    for part: String in keyParts {
      // convert element to json object
      let object = element as! [String:Any]
      element = object[part]
    }
    return element
  }
  
  // TODO: complete this method
  static func reconcileAllocations(_ previousAllocations: JsonArray,_ fetchedAllocations: JsonArray) -> JsonArray {
    var allocations = JsonArray()
    return allocations
  }
}
