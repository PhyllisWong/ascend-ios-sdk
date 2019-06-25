//
//  ViewController.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import PromiseKit

class ViewController: UIViewController {
  
  @IBOutlet weak var textLabel: UITextField!
  let store = LRUCache.share
  var allocations = [JSON]()
  enum DataError: Error { // move this somewhere more sensible
    case taskError
  }

  @IBAction func didPressAlloc(_ sender: Any) {
    // self.getJsonData()
    let jsonPromise = download()
    print("PROMISE: \(jsonPromise)")
    jsonPromise.done { (fetchedJson) in
      print(fetchedJson)
      self.textLabel.text = String(describing: fetchedJson)
      self.allocations.append(fetchedJson)
      }.catch { (error) in
        Log.logger.log(.error, message: error.localizedDescription)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    // self.getData()
//    let client = buildClient()
//    print(client)
  }
}


private extension ViewController {
  
  func download() -> Promise<JSON> {
    let envId = "40ebcd9abf"
    let config = ConfigBuilder(environmentId: envId).buildConfig()
    
    let pastCached = self.store.get(config.getEnvironmentId())
    print("PASTED CACHED: \(pastCached)")
    return Promise<JSON> { resolver -> Void in
      let url = URL(string: "https://participants-phyllis.evolv.ai/v1/40ebcd9abf/allocations?uid=123")
      Alamofire.request(url!)
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
              
              self.store.set(config.getEnvironmentId(), val: json)
              print("UR PROMISED JSON: \(json)")
              let cached = self.store.get(config.getEnvironmentId())
              print("CACHED: \(cached)")
              resolver.fulfill(json)
            }
            
          case .failure(let error):
            resolver.reject(error)
          }
      }
    }
  }
  
  private func getJsonData() {
    let participantBuilder = ParticipantBuilder()
    let participant = participantBuilder.build()
    let client = buildClient()
    print(client)
    let httpClient = HttpClient()
    let envId = "40ebcd9abf"
    let config = ConfigBuilder(environmentId: envId).buildConfig()
    let store = LRUCache(10)
    let alloc = Allocator(config: config, participant: participant)
    let results = alloc.fetchAllocations()
    let cached = store.get(config.getEnvironmentId())
    print("YOUR FETCHED ALLOCATION: \(String(describing: results))")
    print("YOUR CACHED ALLOCATION: \(String(describing: cached))")
  }
  
  private func buildClient() -> AscendClientFactory {
    let envId = "40ebcd9abf"
    let config = ConfigBuilder(environmentId: envId).buildConfig()
    let participantBuilder = ParticipantBuilder()
    let participant = participantBuilder.build()
    return AscendClientFactory(config: config, participant: participant)
  }
  
  private func getData() {
    let participantBuilder = ParticipantBuilder()
    
    let participant = participantBuilder.build()
    let httpClient = HttpClient()
    let envId = "40ebcd9abf"
    let config = ConfigBuilder(environmentId: envId).buildConfig()
    let store = LRUCache(10)
    let alloc = Allocator(config: config, participant: participant)
    let futureAlloc = alloc.fetchAllocations()
    let emitter = EventEmitter(httpClient: httpClient, config: config, participant: participant)
    let ascender = AscendClientImpl(config: config, allocator: alloc, previousAllocations: false, participant: participant, eventEmitter: emitter, futureAllocations: futureAlloc)
    let value = ascender.get(key: "button", defaultValue: "green")
    print("THIS IS YOUR VALUE: \(value)")
  }
}
