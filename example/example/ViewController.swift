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
  
 
  @IBOutlet weak var textView: UITextView!
  
  let store = LRUCache.share
  let cacheName = "MyCache"
  var allocations = JSON()
  enum DataError: Error { // move this somewhere more sensible
    case taskError
  }

  @IBAction func didPressAlloc(_ sender: Any) {
    let url = URL(string: "https://participants-phyllis.evolv.ai/v1/40ebcd9abf/allocations?uid=123")!
    let jsonPromise = HttpClient.get(url: url).done { (fetched) in
      self.allocations = JSON(fetched)
      let previous = self.store.get(self.cacheName)
      if previous != nil {
        self.textView.text = String(describing: previous)
      } else {
        self.store.set(self.cacheName, val: self.allocations)
        self.textView.text = String(describing: self.allocations)
      }
    }
    
    let cached = store.get(cacheName)
    self.textView.text = String(describing: cached)
    print("CACHED: \(String(describing: cached))")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}


private extension ViewController {
  
 
//  private func getJsonData() {
//    let participantBuilder = ParticipantBuilder()
//    let participant = participantBuilder.build()
//    let client = buildClient()
//    print(client)
//    let httpClient = HttpClient()
//    let envId = "40ebcd9abf"
//    let config = ConfigBuilder(environmentId: envId).buildConfig()
//    let store = LRUCache(10)
//    let alloc = Allocator(config: config, participant: participant)
//    let results = alloc.fetchAllocations()
//    let cached = store.get(config.getEnvironmentId())
//    print("YOUR FETCHED ALLOCATION: \(String(describing: results))")
//    print("YOUR CACHED ALLOCATION: \(String(describing: cached))")
//  }
  
  private func buildClient() -> AscendClientFactory {
    let envId = "40ebcd9abf"
    let config = ConfigBuilder(environmentId: envId).buildConfig()
    let participantBuilder = ParticipantBuilder()
    let participant = participantBuilder.build()
    return AscendClientFactory(config: config, participant: participant)
  }
  
//  private func getData() {
//    let participantBuilder = ParticipantBuilder()
//
//    let participant = participantBuilder.build()
//    let httpClient = HttpClient()
//    let envId = "40ebcd9abf"
//    let config = ConfigBuilder(environmentId: envId).buildConfig()
//    let store = LRUCache(10)
//    let alloc = Allocator(config: config, participant: participant)
//    let futureAlloc = alloc.fetchAllocations()
//    let emitter = EventEmitter(httpClient: httpClient, config: config, participant: participant)
//    let ascender = AscendClientImpl(config: config, allocator: alloc, previousAllocations: false, participant: participant, eventEmitter: emitter, futureAllocations: futureAlloc)
//    let value = ascender.get(key: "button", defaultValue: "green")
//    print("THIS IS YOUR VALUE: \(value)")
//  }
}
