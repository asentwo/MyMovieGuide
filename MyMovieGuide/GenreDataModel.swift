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
  
  public let id : NSNumber
  public let name : String
  
  
  public init?(json: JSON) {
    
    guard let id : NSNumber = "id" <~~ json,
      let name : String = "name" <~~ json
      else {return nil}
    self.id = id
    self.name = name
    
  }
  
  
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

