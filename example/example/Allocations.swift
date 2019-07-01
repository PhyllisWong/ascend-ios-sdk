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
  let allocations: [JSON]
  let audience : Audience = Audience()
  
  init (allocations: [JSON]) {
    self.allocations = allocations
  }
  
  func getMyType<T>(_ element: T) -> Any? {
    return type(of: element)
  }

  func getValueFromAllocations<T>(_ key: String, _ type: T, _ participant: EvolvParticipant) throws -> JSON? {
    var keyParts = [String]()
    keyParts = key.components(separatedBy: "\\.")
    
    if (keyParts.isEmpty()) { throw EvolvKeyError(rawValue: "Key provided was empty.")! }
    
    for a in self.allocations {
      var allocation = a
      print("Iterating through the array \(a)")
      let genome = allocation["genome"]
      let element = try getElementFromGenome(genome:genome, keyParts: keyParts)
      print("ELEMENT: \(element)")
      return element
    }
//    do {
//        // iterate through the array of json
//        // convert each item into a json object
//        // check to see if there is an audience filter
//        // if not... traverse the genome object and get the value at each key part
//        // return new jsonObj with the element and type
//      } else {
//        let keyPartsStr = keyParts.map{ String($0) }
//        let eid = allocation["eid"]
//        Log.logger.log(.debug, message: "Unable to find key \(keyPartsStr) in experiment \(String(describing: eid))")
//      }
//    } catch let error {
//      Log.logger.log(.debug, message: "Key provided was empty.")
//      return ["":""]
//    }
//    return self.allocations
    let value = JSON(["string": "Green"])
    return value
  }
  
  // THIS WASN"T HELPFUL!!!!!!
  // let rawString = genome.rawString()!
  // print("RAW STRING: \(rawString)")
  // let dict = genome.dictionary
  // print("DICT: \(dict)")
  private func getElementFromGenome(genome: JSON, keyParts: [String]) throws -> JSON {
    var element: JSON = genome
    if element == nil {
      throw EvolvKeyError(rawValue: "Allocation genome was empty")!
    }
    
    for part: String in keyParts {
      do {
        let object = element[part]
        element = object
        break
      } catch {
        throw EvolvKeyError(rawValue: "element fails")!
      }
    }
    return element
  }
  
  static public func reconcileAllocations(previousAllocations: [JSON], currentAllocations: [JSON]) -> [JSON] {
    var allocations = [JSON]()
    
    for ca in currentAllocations {
      let currentEid = String(describing: ca["eid"])
      var previousFound = false
      
      for pa in previousAllocations {
        var previousEid = String(describing: pa["eid"])
        
        if currentEid.elementsEqual(previousEid) {
          allocations.append(pa)
          previousFound = true
        }
      }
      if !previousFound { allocations.append(ca) }
    }
    return allocations
  }
  
  
  public func getActiveExperiments() -> Set<String> {
    var activeExperiments = Set<String>()
    for a in allocations {
      let eid = String(describing: a["eid"])
      activeExperiments.insert(eid)
    }
  return activeExperiments
  }
}
