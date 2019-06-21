//
//  GenericClass.swift
//  example
//
//  Created by phyllis.wong on 6/20/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

protocol DataType {}

extension DataType {
  func getMyType() -> Self.Type {
    return type(of: self)
  }
}

protocol DataProvider {
  associatedtype ProvidedData: DataType
  func giveData() -> ProvidedData
}

class GenericClass<T> {
  typealias ProvidedData = DataType
  
  let element: T
  
  init (element: T) {
    self.element = element
  }
  
  func getMyType<T>() -> T.Type.Type {
    return type(of: T.self)
  }
}
