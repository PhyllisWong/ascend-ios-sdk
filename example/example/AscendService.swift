//
//  Networking.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import PromiseKit
import DynamicJSON
import Alamofire

class HttpClient: HttpService {
  
  static func get(url: URL) -> Promise<JSON> {
    return Promise<JSON> { resolver -> Void in
      
      Alamofire.request(url)
        .validate()
        .responseJSON { response in
          switch response.result {
          case .success(let json):
            let json = JSON()
            if let data = response.data {
              guard let json = try? JSON(data: data) else {
                resolver.reject("Error" as! Error)
                return
              }
              print("UR PROMISED JSON: \(json)")
              resolver.fulfill(json)
            }
          case .failure(let error):
            resolver.reject(error)
          }
      }
    }
  }
  
  static func post(url: URL) -> Promise<JSON> {
    return Promise<JSON> { resolver -> Void in
      
      Alamofire.request(url, method: .post, encoding: JSONEncoding.default)
        .validate()
        .responseJSON { response in
          switch response.result {
          case .success(let json):
            if let data = response.data {
              guard let json = try? JSON(data: data) else {
                resolver.reject("Error" as! Error)
                return
              }
              resolver.fulfill(json)
            }
          case .failure(let error):
            resolver.reject(error)
          }
      }
      
    }
  }
}
