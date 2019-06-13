//
//  Networking.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

protocol Networking {
  static func get(fromUrl url: URL, completion: @escaping (Any?) -> ())
}

class NetworkManager: Networking {
  static func get(fromUrl url: URL, completion: @escaping (Any?) -> ()) {
    let session = URLSession.shared
    let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
      
      // 1 check for errors
      if error != nil || data == nil {
        // self.handleClientError(error) // create a function that can deal with the error
        print("OH NO! An error occured ...")
        return
      }
      
      // 2 check the status code
      guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else {
          // self.handleServerError(response)
          print("Server Error")
          return
      }
      
      // 3 check that we got back JSON and not html or xml or some wack shit
      guard let mime = response?.mimeType, mime == "application/json" else {
        print("Wrong MIME type!")
        return
      }
      
      // 4 serialize the data to json
      do {
        let json = try JSONSerialization.jsonObject(with: data!, options: [])
        completion(json)
      } catch {
        print("JSON error: \(error.localizedDescription)")
      }
    })
    task.resume()
  }
  
  
}

// - MARK: final class makes it so it can't be extended or overridden
public class HttpClient : HttpServiceProvider {
  
  // FIXME: change Any to NSDictionary for this method
  static func get(url: URL, completion: @escaping (Any?) -> ()) {
    let urlString = "https://participants.evolv.ai/v1/40ebcd9abf?uid=640E05D3-8837-43B8-A060-2427EE1B684C&sid=2F3B882D-8259-4EF9-930C-62B3E4AFC871"
    let url = URL(string: urlString)!
    NetworkManager.get(fromUrl: url) { (response) in
      guard let response = response else {
        return completion(nil)
      }
      completion(response)
    }
  }
  
  static func post(url: String, jsonArray: [[String : Any]]) {
    print("working on it")
  }
  
}
//
//public enum Resource {
//  case getConfig
//
//  public var resource: (method: HTTPMethod, route: String) {
//    let environment_id = "5eadef5e68"
//    switch self {
//    case .getConfig:
//      return (.get, "/v1/\(environment_id)/configuration")
//    }
//  }
//}

