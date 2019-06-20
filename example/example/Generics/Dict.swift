//
//  Dict.swift
//  example
//
//  Created by phyllis.wong on 6/20/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

class Dict {
  func pairs<Key, Value>(from dictionary: [Key: Value]) -> [(Key, Value)] {
    return Array(dictionary)
  }

  func testing() {
    let somePairs = pairs(from: ["min": 199, "max": 299])
    print(somePairs)
  }
}
