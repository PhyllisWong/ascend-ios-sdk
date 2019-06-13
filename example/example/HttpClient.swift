//
//  HttpClient.swift
//  example
//
//  Created by phyllis.wong on 6/11/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

protocol HttpServiceProvider: class {

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
  static func get(url: URL, completion: @escaping (Any?) -> ())
  
  // TODO: this is a copy pasta from get method, FIXME
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
  static func post(url: String, jsonArray: [[String: Any]])
}
