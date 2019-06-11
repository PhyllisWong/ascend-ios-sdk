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
    
    let url = URL(string: "https://participants-stg.evolv.ai/v1/5eadef5e68/configuration")!
    let session = URLSession.shared
    
    let task = session.dataTask(with: url, completionHandler: { data, response, error in
      // do something with the stuff
      
      // 1 check for errors
      if error != nil {
        // OH NO! An error occured ...
        // self.handleClientError(error) // create a function that can deal with the error
        print(error ?? "SOMETHING REALLY BAD HAPPEND!")
      }
      
      // 2 check the status code
      guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else {
          // self.handleServerError(response)
          print(response ?? "SERVER SENT BACK A BAD STATUS CODE")
          return
      }
      
      // 3 check that we got back JSON
      guard let mime = response?.mimeType, mime == "application/json" else {
        print("Wrong MIME type!!!!!!")
        return
      }
      
      // 4 check what the data was that came back
      if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
        print(json)
      }
    })
    
    task.resume()
  }
}

