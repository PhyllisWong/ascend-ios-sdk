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
  var allocations = [JSON]()
  enum DataError: Error { // move this somewhere more sensible
    case taskError
  }

  @IBAction func didPressAlloc(_ sender: Any) {
   getJsonData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let envId = "40ebcd9abf"
    let httpClient = EvolvHttpClient()
    let configBuilder = EvolvConfig.builder(environmentId: envId, httpClient: httpClient)
    let config = configBuilder.build()
    print(config)
    let participantBuilder = EvolvParticipant.builder()
    let participant = participantBuilder.build()
    print(participant)
  }
}


private extension ViewController {
  
 
  private func getJsonData() {
//    let participantBuilder = ParticipantBuilder()
//    let participant = participantBuilder.build()
//    let envId = "40ebcd9abf"
//    let config = ConfigBuilder(environmentId: envId).buildConfig()
//    let store = LRUCache.share
//    let alloc = Allocator(config: config, participant: participant)
//    let results = alloc.fetchAllocations()
//    print("YOUR FETCHED ALLOCATION: \(String(describing: results))")
  }
  
//  private func buildClient() -> EvolvClientFactory {
//    let envId = "40ebcd9abf"
//    let config = ConfigBuilder(environmentId: envId).buildConfig()
//    let participantBuilder = ParticipantBuilder()
//    let participant = participantBuilder.build()
//    return EvolvClientFactory(config: config, participant: participant)
//  }
  
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
//    let evolver = EvolvClientImpl(config: config, allocator: alloc, previousAllocations: false, participant: participant, eventEmitter: emitter, futureAllocations: futureAlloc)
//    let value = evolver.get(key: "button", defaultValue: "green")
//    print("THIS IS YOUR VALUE: \(value)")
//  }
}
