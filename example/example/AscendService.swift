//
//  Networking.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON
import Alamofire

public protocol HttpProtocol {

  /**
   * Performs a GET request using the provided url.
   * <p>
   *     This call is asynchronous, the request is sent and a completable future
   *     is returned. The future is completed when the result of the request returns.
   *     The timeout of the request is determined in the implementation of the
   *     HttpClient.
   * </p>
   * @param url a valid url representing a call to the Participant API.
   * @return a response future
   */
  func get(_ url: URL) -> PromiseKit.Promise<JSON>

  /**
   * Performs a POST request using the provided url.
   * <p>
   *     This call is asynchronous, the request is sent and a completable future
   *     is returned. The future is completed when the result of the request returns.
   *     The timeout of the request is determined in the implementation of the
   *     HttpClient.
   * </p>
   * @param url a valid url representing a call to the Participant API.
   * @return a response future
   */
  func post(_ url: URL) -> PromiseKit.Promise<JSON>

}

public typealias JsonArray = [JSON]

public class HttpClient: HttpProtocol {
  
    public func get(_ url: URL) -> Promise<JSON> {
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
              resolver.fulfill(json)
            }
          case .failure(let error):
            resolver.reject(error)
          }
      }
    }
  }
  
  public func post(_ url: URL) -> Promise<JSON> {
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

