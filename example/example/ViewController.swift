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
  
  let store = DefaultAllocationStore(size: 1000)
  var allocations = [JSON]()
  var client : EvolvClientProtocol?

  @IBAction func didPressAlloc(_ sender: Any) {
    getJsonData()
  }

  
  // This is also necessary when extending the superclass.
  required init?(coder aDecoder: NSCoder) {
    let envId = "40ebcd9abf"
    let httpClient = EvolvHttpClient()
    let config = EvolvConfig.builder(environmentId: envId, httpClient: httpClient).build()
    let participant = EvolvParticipant.builder().build()
    self.client = EvolvClientFactory(config: config, participant: participant).client as! EvolvClientImpl
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // Client makes the call to get the allocations
   
  }
}


private extension ViewController {
  
  private func getJsonData() -> Void {
    guard let client = self.client else {
      return
    }
    let key = "button\\.background\\.height\\.width"
    let someValue = client.get(key: key, defaultValue: "green")
    print(someValue)
  }
  
//  private func buildClient() -> EvolvClientImpl {
//    let envId = "40ebcd9abf"
//    let httpClient = EvolvHttpClient()
//    let config = EvolvConfig.builder(environmentId: envId, httpClient: httpClient).build()
//    let participant = EvolvParticipant.builder().build()
//    return EvolvClientFactory(config: config, participant: participant).client as! EvolvClientImpl
//  }
}
