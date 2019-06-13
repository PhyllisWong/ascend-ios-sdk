//
//  ViewController.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  enum DataError: Error { // move this somewhere more sensible
    case taskError
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.getJsonData()
    
    let envId = "envID"
    let builder = ConfigBuilder(environmentId: envId)
    print(builder.buildConfig().getDomain())
    print(builder.buildConfig().getHttpScheme())
    print(builder.buildConfig().getVersion())
    print(builder.buildConfig().getEnvironmentId())
    print(builder.buildConfig().getAscendAllocationStore())
    print(builder.buildConfig().getHttpClient())
    print(builder.buildConfig().getExecutionDispatch())
  }
}


private extension ViewController {
  
  private func getJsonData() {
    let urlString = "https://participants-phyllis.evolv.ai/v1/40ebcd9abf/allocations?uid=123"
    HttpService.get(url: urlString, completion: { [weak self] (response) in
      // unwraps the optional response
      guard let response = response else {
        print("OOPS!")
        return
      }
      // let really_bad_var_name = response // as! Dictionary<String, [Dictionary<String, Any>]>
      print("YOUR ALLOCATION: \(response)")
      // dump(response) // shows it as swift data types
    })
  }
}
