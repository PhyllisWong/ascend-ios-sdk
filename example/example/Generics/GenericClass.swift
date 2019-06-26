//
//  GenericClass.swift
//  example
//
//  Created by phyllis.wong on 6/20/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

class GenericValue<T> {
  
  let value: T
  init(_ value: T) {
    self.value = value
  }
  
  func getMyType<T>() -> T.Type.Type {
    return type(of: T.self)
  }
}

class IntValue: GenericValue<Int> {}
class StringValue: GenericValue<String> {}





