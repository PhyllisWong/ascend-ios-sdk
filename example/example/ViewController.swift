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
  }
}


private extension ViewController {
  
  private func getJsonData() {
    HttpService.get(completion: { [weak self] (response) in
      // unwraps the optional response
      guard let response = response else {
        print("OOPS!")
        return
      }
       let really_bad_var_name = response // as! Dictionary<String, [Dictionary<String, Any>]>
      print("THIS IS THE STUFF YOU ASKED FOR: \(response)")
      // dump(response) // shows it as swift data types
    })
  }
  
}
