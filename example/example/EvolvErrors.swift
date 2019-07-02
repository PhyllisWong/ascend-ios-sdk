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
  case errorMessage
}

extension EvolvKeyError: LocalizedError {
  var errorDescription: String? { return NSLocalizedString(rawValue, comment: "") }
}
