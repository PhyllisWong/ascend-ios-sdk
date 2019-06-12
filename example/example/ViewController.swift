//
//  ViewController.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  enum DataError: Error {
    case taskError
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.getConfig()
  }
}


private extension ViewController {
  
  private func getConfig() {
    HttpService.get(completion: { [unowned self ] (response) in
      guard let response = response else { return }
      print(response)
    })
  }
  
}
