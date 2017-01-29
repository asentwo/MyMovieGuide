//
//  ViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/25/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

  let networkSessionCreator = NetworkManager.sharedManager
  let alamofireSessionManager = AlamoFireNetworkManager.sharedManager
  
  override func viewDidLoad() {
    super.viewDidLoad()

    PopularData.updateAllData(urlExtension:"popular", completionHandler: { results in
      
            guard let results = results else {
      
              print("There was an error retrieving info")
      
              return
            }
      print(results)
      
    })



  }
}

