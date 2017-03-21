//
//  PeopleExtendedDataModel.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 3/3/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import Gloss


public struct CastExtended: Decodable {
  
  public let castExtended : [CastExtendedData]?
  
  public init?(json: JSON) {
    
    castExtended = "cast" <~~ json
  }
}

public struct CastExtendedData : Decodable {
  
  public let character : String
  public let title : String
  public let releaseDate : String?
  public let poster : String?
  public let id: NSNumber
  
  public init?(json: JSON) {
    
    guard let character : String = "character" <~~ json,
      let title : String  = "title" <~~ json,
      let id : NSNumber = "id" <~~ json
      else {return nil}
    
    self.character = character
    self.title = title
    self.releaseDate = "release_date" <~~ json
    self.poster = "poster_path" <~~ json
    self.id = id
  }
  //https://api.themoviedb.org/3/person/73457/movie_credits?api_key=edd0a1862823ffe4afff6c230daf2c92&language=en-US
  // https://api.themoviedb.org/3/movie/135397/credits?api_key=edd0a1862823ffe4afff6c230daf2c92&region=US&append_to_response=videos,images
  //https://api.themoviedb.org/3/person/73457?api_key=edd0a1862823ffe4afff6c230daf2c92&region=US&append_to_response=videos,images
  
  //urlExtension for CastExtended: "\(id)/movie_credits"
  static func updateAllData(urlExtension: String, completionHandler:@escaping (_ details: CastExtended?) -> Void){
    
    let nm = NetworkManager.sharedManager
    
    nm.getJSONData(type:"person", urlExtension: urlExtension, completion: {
      data in
      
      if let jsonDictionary = nm.parseJSONData(data)
      {
        guard let cast = CastExtended(json: jsonDictionary)
          
          else {
            print("Error initializing object")
            return
        }

        completionHandler(cast)
      }
    })
  }
}
