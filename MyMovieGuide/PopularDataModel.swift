//
//  PopularDataModel.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/27/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import Gloss



public struct PopularResults: Decodable {
  
  public let results: [PopularData]?
  
  public init?(json: JSON) {
    
    results = "results" <~~ json
  }
}


public struct PopularData: Decodable {
  
  public let poster : String
  public let overView : String
  public let title : String
  public let backdrop : String
  
  public init? (json: JSON) {
    
    guard let poster : String = "poster_path" <~~ json,
      let overview : String  = "overview" <~~ json,
      let title : String  = "title" <~~ json,
      let backdrop : String  = "backdrop_path" <~~ json
      else { return nil }
    
    self.poster = poster
    self.overView = overview
    self.title = title
    self.backdrop = backdrop
  }
  
  
  
  static func updateAllData(urlExtension: String, completionHandler:@escaping (_ details: [PopularData]?) -> Void){
    
    let nm = NetworkManager.sharedManager
    
    nm.getJSONData(urlExtension: urlExtension, completion: {
      data in
      
      if let jsonDictionary = nm.parseJSONFromData(data)
      {
        guard let popularResults = PopularResults(json: jsonDictionary)
          
          else {
            print("Error initializing object")
            return
        }

        guard let popularData = popularResults.results
          else {
            print("No such item")
            return
        }
        
        completionHandler(popularData)
      }
    })
  }
}
