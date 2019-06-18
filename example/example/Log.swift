//
//  Log.swift
//  example
//
//  Created by phyllis.wong on 6/17/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

protocol Logger {
  func log(_ level: Log.Level, message: String)
}

struct Log {
  
  enum Level: Int {
    case debug
    case error
    case noLogging
  }
  
  struct BasicLogger: Logger {
    static let sharedInstance = BasicLogger()
    
    func log(_ level: Level, message: String) {
      var prefix = ""
      
      switch level {
      case .debug:
        prefix = "Ascend"
      case .noLogging:
        prefix = ""
      case .error:
        prefix = "Error"
      }
      NSLog("%@", "\(prefix): \(message)")
    }
  }
  
  static var level = Level.noLogging
  static public var logger: Logger = BasicLogger()
  
  static func debug(_ msg: @autoclosure () -> String) {
    if level.rawValue <= Level.debug.rawValue {
      logger.log(.debug, message: msg())
    }
  }
}

protocol TypeIdentifying { }

extension TypeIdentifying {
  var typeName: String {
    return String(describing: type(of: self))
  }
  func typeName(and method: String, appending suffix: String = " ") -> String {
    return typeName + "." + method + suffix
  }
  static var typeName: String {
    return String(describing: self)
  }
  static func typeName(and method: String, appending suffix: String = " ") -> String {
    return typeName + "." + method + suffix
  }
}
