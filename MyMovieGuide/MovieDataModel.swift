//
//  PopularDataModel.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/27/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import Gloss



// Used for Popular/ Now Playing and Upcoming Movie Objects
public struct ResultsMovieData: Decodable {
  
  public let results: [MovieData]?
  
  public init?(json: JSON) {
    
    results = "results" <~~ json
  }
}

public struct MovieData: Decodable {
  
  public let poster : String
  public let overView : String
  public let title : String
  public let backdrop : String
  public let id: NSNumber
  
  public init? (json: JSON) {
    
    guard let poster : String = "poster_path" <~~ json,
      let overview : String  = "overview" <~~ json ?? "N/A",
      let title : String  = "title" <~~ json ?? "N/A",
      let backdrop : String  = "backdrop_path" <~~ json,
      let id : NSNumber = "id" <~~ json
      else { return nil }
    
    self.poster = poster
    self.overView = overview
    self.title = title
    self.backdrop = backdrop
    self.id = id
  }
  
  
  
  //urlExtensions: "popular", "upcoming", "now_playing"
  static func updateAllData(urlExtension: String, completionHandler:@escaping (_ details: [MovieData]?) -> Void){
    
    let nm = NetworkManager.sharedManager
    
    nm.getJSONData(type:"movie", urlExtension: urlExtension, completion: {
      data in
      
      if let jsonDictionary = nm.parseJSONData(data)
      {
        guard let movieResults = ResultsMovieData(json: jsonDictionary)
          
          else {
            print("Error initializing object")
            return
        }
        
        //  print(jsonDictionary)
        
        guard let movieData = movieResults.results
          else {
            print("No such item")
            return
        }
        
        completionHandler(movieData)
      }
    })
  }
}
