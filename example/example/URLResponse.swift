//
//  URLResponse.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

extension URLResponse {
  var httpStatusCode: Int? {
    return (self as? HTTPURLResponse)?.statusCode
  }
  
  var httpHeaderEtag: String? {
    return (self as? HTTPURLResponse)?.httpHeaderEtag
  }
}
