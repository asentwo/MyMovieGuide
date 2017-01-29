//
//  AlamoFireNetworkManager.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/26/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import Alamofire

class AlamoFireNetworkManager: NSObject {
  
  static let sharedManager = AlamoFireNetworkManager()
  
  private let apiKey = "edd0a1862823ffe4afff6c230daf2c92"
  
  let baseURL = "https://nomadlist.com/api/v2/list"
  
  func getAllInfoDump(urlExtension: String) {
    
    Alamofire.request("\(baseURL)\(urlExtension)").responseJSON { response in
      print(response.request!)  // original URL request
      print(response.response!) // HTTP URL response
      print(response.data!)     // server data
      print(response.result)   // result of response serialization
      
      if let JSON = response.result.value {
        print("JSON: \(JSON)")
      }
    }
  }
  
}
