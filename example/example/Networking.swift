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

//public struct RestClient {
//  let environment_id = "5eadef5e68"
//  var baseURL: String

  // FIXME: this is failable, change the force unwrapping later
//  let url = URL(string: "https://participants-stg.evolv.ai/v1/5eadef5e68/configuration")!
//  let session = URLSession.shared
//  
//  let task = session.dataTask(with: url, completionHandler: { data, response, error in
//    // do something with the stuff
//    print(data)
//    print(response)
//    print(error)
//  })
//  
//  task.resume()
//
//  var defaultHeader: HTTPHeaders = [
//    "Content-Type" : "application/json"
//  ]
//
//  public init(baseURL: ServerURL = .base) {
//    self.baseURL = baseURL.rawValue
//  }
  
//}

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

//class networking {
//  let configuration = URLSessionConfiguration.ephemeral
//  let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
//  let environment_id = "5eadef5e68"
//  let url: String = "https://participants-stg.evolv.ai/v1/\(environment_id)/configuration"
//
//
//  let task = session.dataTask(with: url, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
//    // Parse the data in the response and use it
//  })
//  task.resume()
//
//}

//  public func request(_ resource: Resource,
//                      parameters: [String : Any] = [:]
//    headers: HTTPHeaders = [:]) -> Promise < JSON > {
//    return Promise { fulfill, reject in
//      let method = resource.resource.method
//      let url = "\(baseURL)\(resource.resource.route)"
//      var header = defaultHeader
//
//      /*
//       prepare additional stuff like:
//       - more header params
//       - edit/change the endpoint when something specifically is called
//       - creae a signature for security purposes\
//       ect.
//       */
//
//      Alamofire.request(u, method: method,
//                        parameters: method == .get ? nil : params,
//                        encoding: JSONEncoding.default,
//                        headers: headers).responseJSON { (response) in
//
//                          switch response.result {
//                            case .success(let json):
//                              // If there is not JSON data, cause an error ('reject' function)
//                              guard let json = json as? JSON else {
//                                return reject(AFError.responseValidationFailed(reason: .dataFileNil))
//                              }
//                              // pass the JSON data into the fulfill function, so we can receive the value
//                              fulfill(json)
//                            case .failure(let error):
//                              // pass the error into the reject function, so we can check what causes the error
//                              reject(error)
//                          }
//      }
//
//    }
//  }
//
//}


// FIXME: is this needed with Alomofire and PromiseKit?
//extension URLSession {
//  func request(url: URL) -> Future<Data> {
//    // Start by constructing a Promise, that will later be
//    // returned as a Future
//    let promise = Promise<Data>()
//
//    // Perform a data task, just like normal
//    let task = dataTask(with: url) { data, _, error in
//      // Reject or resolve the promise, depending on the result
//      if let error = error {
//        promise.reject(with: error)
//      } else {
//        promise.resolve(with: data ?? Data())
//      }
//    }
  
//    task.resume()
//
//    return promise
//  }
//}
