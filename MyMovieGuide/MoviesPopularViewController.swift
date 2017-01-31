//
//  ViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/25/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit


class MoviesPopularViewController: UIViewController {
  
  
  @IBOutlet weak var segmentedController: UISegmentedControl!
  
  
  
  let networkSessionCreator = NetworkManager.sharedManager

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //urlExtensions for Movies: "popular", "upcoming", "now_playing"
    //urlExtension for People: "popular"
    //urlExtension for Genres: "list"
    GenreData.updateAllData(urlExtension:"list", completionHandler: { results in
      
      guard let results = results else {
        
        print("There was an error retrieving info")
        
        return
      }
      print(results)
      
    })
  }
  
  
  
  
  
  
}

