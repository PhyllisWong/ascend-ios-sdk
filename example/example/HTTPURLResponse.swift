//
//  HTTPURLResponse.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
  struct StatusCodes {
    //swiftlint:disable:next identifier_name
    static let ok = 200
    static let accepted = 202
    static let notModified = 304
    static let badRequest = 400
    static let unauthorized = 401
    static let methodNotAllowed = 405
    static let internalServerError = 500
    static let notImplemented = 501
  }
}
