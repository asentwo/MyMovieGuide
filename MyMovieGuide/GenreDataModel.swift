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
            print("No genre data exists")
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

//Made of type Equatable to make it comparable so can check for duplicatesGenre
public struct GenrePosters: Decodable, Equatable{
  
  public let poster : String
  
  public init? (json: JSON) {
    
    guard let poster: String = "poster_path" <~~ json
      else {return nil}
    self.poster = poster
  }
  public static func ==(lhs: GenrePosters, rhs: GenrePosters) -> Bool {
    return lhs.poster == rhs.poster
  }
  
  
  //https://api.themoviedb.org/3/genre/99/movies?api_key=edd0a1862823ffe4afff6c230daf2c92&language=en-US
  //urlExtension for GenrePosters: "movies"
  static func updateGenrePoster(genreID: NSNumber, urlExtension: String, completionHandler:@escaping (_ details: [String]) -> Void){
    
    let nm = NetworkManager.sharedManager
    
    nm.getJSONData(type:"genre/\(genreID)", urlExtension: urlExtension, completion: {
      data in
      
      
      
      if let jsonDictionary = nm.parseJSONData(data)
      {
        guard let genrePosters = ResultsGenrePosters(json: jsonDictionary)
          
          else {
            print("Error initializing object")
            return
        }

        guard let posters = genrePosters.results
          
          else {
            print("No poster exists for genre: \(genreID)")
            return
        }
        
        let postersArray = posters.map {$0.poster}// converts custom object "GenrePosters" to String(poster value)
        completionHandler(postersArray)
      }
    })
  }
}

