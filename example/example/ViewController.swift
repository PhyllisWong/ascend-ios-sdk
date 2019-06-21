//
//  ViewController.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import UIKit
import DynamicJSON

class ViewController: UIViewController {
  
  enum DataError: Error { // move this somewhere more sensible
    case taskError
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.getJsonData()
    // self.getOtherShit()
  }
}


private extension ViewController {
  
  private func getJsonData() {
    let participantBuilder = ParticipantBuilder()
    
    let participant = participantBuilder.build()
    let httpClient = HttpClient()
    let envId = "40ebcd9abf"
    let config = ConfigBuilder(environmentId: envId).buildConfig()
    let alloc = Allocator(config: config, participant: participant, httpClient: httpClient)
    let results = alloc.fetchAllocations()
    print("YOUR FETCHED ALLOCATION: \(String(describing: results))")
  }
  
  private func getOtherShit() {
    let participantBuilder = ParticipantBuilder()
    
    let participant = participantBuilder.build()
    let httpClient = HttpClient()
    let envId = "40ebcd9abf"
    let config = ConfigBuilder(environmentId: envId).buildConfig()
    let alloc = Allocator(config: config, participant: participant, httpClient: httpClient)
    let futureAloc = [alloc.fetchAllocations()]
    let emitter = EventEmitter(httpClient: httpClient, config: config, participant: participant)
    let ascender = AscendClientImpl(config: config, allocator: alloc, previousAllocations: false, participant: participant, eventEmitter: emitter, futureAllocations: futureAloc)
    let value = ascender.get(key: "button", defaultValue: "green")
    print("THIS IS YOUR VALUE: \(value)")
  }
}
