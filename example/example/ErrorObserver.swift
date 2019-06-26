//
//  ErrorHandling.swift
//  example
//
//  Created by phyllis.wong on 6/17/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

enum NetworkingError: String, Error {
  case invalidRequest = "Invalid request"
  case invalidUrl
  case response
  case data = "No data"
}


extension NetworkingError: LocalizedError {
  var errorDescription: String? { return NSLocalizedString(rawValue, comment: "") }
}

enum EvolvKeyError: String, Error {
  case keyError = "Invalid Key"
}

extension EvolvKeyError: LocalizedError {
  var errorDescription: String? { return NSLocalizedString(rawValue, comment: "") }
}


struct ErrorObserver {
  private(set) var key: UUID
  weak private(set) var owner: EvolvObserverOwner?
  var errorHandler: EvolvErrorHandler?
  
  init(owner: EvolvObserverOwner, errorHandler: @escaping EvolvErrorHandler) {
    key = UUID()
    self.owner = owner
    self.errorHandler = errorHandler
  }
}

extension ErrorObserver: Equatable {
  static func == (lhs: ErrorObserver, rhs: ErrorObserver) -> Bool {
    return lhs.key == rhs.key && lhs.owner === rhs.owner
  }
}

#if DEBUG
extension ErrorObserver {
  mutating func clearOwner() {
    owner = nil
  }
}
#endif
