//
//  GenreModel.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/29/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import Gloss


public struct Genres: Decodable {
  
  public let genres : [GenreData]?
  
  public init?(json: JSON) {
    
    genres = "genres" <~~ json
  }
}


public struct GenreData : Decodable {
  
  public let id : NSNumber?
  public let name : String
  
  
  public init?(json: JSON) {
    
    guard let name : String = "name" <~~ json
      else {return nil}
    
    self.id = "id" <~~ json
    self.name = name
    
  }
 //https://api.themoviedb.org/3/genre/movie/list?api_key=edd0a1862823ffe4afff6c230daf2c92&language=en-US
  
  //urlExtension for Genres: "list"
  static func updateAllData(urlExtension: String, completionHandler:@escaping (_ details: [GenreData]?) -> Void){
    
    let nm = NetworkManager.sharedManager
    
    nm.getJSONData(type:"genre/movie", urlExtension: urlExtension, completion: {
      data in
      
      if let jsonDictionary = nm.parseJSONData(data)
      {
        guard let genres = Genres(json: jsonDictionary)
          
          else {
            print("Error initializing object")
            return
        }
        
      //  print(jsonDictionary)
        
        guard let genreData = genres.genres
          else {
            print("No such item")
            return
        }
        
        completionHandler(genreData)
      }
    })
  }
}


public struct ResultsGenrePosters: Decodable {
  
  public let results :  [GenrePosters]?
  
  public init?(json: JSON) {
    results = "results" <~~ json
  }
}


public struct GenrePosters: Decodable {
  
  public let poster : String
  
  public init? (json: JSON) {

    guard let poster: String = "poster_path" <~~ json
    else {return nil}
  self.poster = poster
  }

 // https://api.themoviedb.org/3/genre/28/movies?api_key=edd0a1862823ffe4afff6c230daf2c92&language=en-US
 //urlExtension for GenrePosters: "movies"
  static func updateGenrePoster(genreID: NSNumber, urlExtension: String, completionHandler:@escaping (_ details: [String]) -> Void){
    
    var posterArray: [String] = []
    
    let nm = NetworkManager.sharedManager
    
    nm.getJSONData(type:"genre/\(genreID)", urlExtension: urlExtension, completion: {
      data in
      
      if let jsonDictionary = nm.parseJSONData(data)
      {
        guard let genrePoster = ResultsGenrePosters(json: jsonDictionary)
          
          else {
            print("Error initializing object")
            return
        }
        guard let posterString = genrePoster.results?[0].poster//This is where I want to check to see if array already contains the string
          
          else {
            print("No such item")
            return
        }
        posterArray.append(posterString)
        
      }
      completionHandler(posterArray)
    })
  }
}
