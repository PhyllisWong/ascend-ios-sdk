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

typealias JSON = [String : Any]

// enum used for convenience purposes (optional)
public enum ServerURL: String {
  case base = "https://participants-stg.evolv.ai"
  
  // additional endpoints
}

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
final class HttpService: HttpClient {
  
  public var url: String
  
  init() {
    self.url = "https://participants-phyllis.evolv.ai/v1/40ebcd9abf/allocations?uid=123"
  }
  
  
  // FIXME: change Any to NSDictionary for this method
  static func get(url: String, completion: @escaping (Any?) -> ()) {
    // TODO: create a method that creates this give a uid that is not checked
    let stringUrl = url
    guard let url = URL(string: stringUrl) else { return completion(nil) }
    
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

public enum Resource {
  case getConfig
  
  public var resource: (method: HTTPMethod, route: String) {
    let environment_id = "5eadef5e68"
    switch self {
    case .getConfig:
      return (.get, "/v1/\(environment_id)/configuration")
    }
  }
}

