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

public struct MovieData: Decodable, Equatable {
  
  public let poster : String?
  public let overView : String?
  public let title : String?
  public let backdrop : String?
  public let id: NSNumber?
  
  public init? (json: JSON) {
    
    self.poster  = "poster_path" <~~ json
    self.overView = "overview" <~~ json
    self.title = "title" <~~ json 
    self.backdrop = "backdrop_path" <~~ json
    self.id = "id" <~~ json
  }
  
  public static func ==(lhs: MovieData, rhs: MovieData) -> Bool {
    return lhs.poster == rhs.poster
    
  }
  
  
  
  
  //urlExtensions: "popular", "upcoming", "now_playing"
  static func updateAllData(type: String, urlExtension: String,completionHandler:@escaping (_ details: [MovieData]?) -> Void){
    
    let nm = NetworkManager.sharedManager
    
    nm.getJSONData(type:type, urlExtension: urlExtension, completion: {
      data in
      
      if let jsonDictionary = nm.parseJSONData(data)
      {
        guard let movieResults = ResultsMovieData(json: jsonDictionary)
          
          else {
            print("Error initializing object")
            return
        }

          guard let movieData = movieResults.results
            else {
            print("No such item")
            return
        }
     //   print(movieData)

        completionHandler(movieData)
      }
    })
  }
}
