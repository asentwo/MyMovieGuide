//
//  ActorsModel.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/29/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import Gloss


public struct ResultsPeopleData: Decodable {
  
  public let results: [PeopleData]?
  
  public init?(json: JSON) {
    
    results = "results" <~~ json
  }
}


public struct knownForArray : Decodable {
  
  public let poster : String
  public let overview : String
  public let releaseDate : String
  public let title : String
  public let id : NSNumber
  public let backdrop : String
  
  public init?(json: JSON) {
    
    guard let poster : String = "poster_path" <~~ json,
      let overview : String = "overview" <~~ json ?? "N/A",
      let releaseDate : String = "release_date" <~~ json ?? "N/A",
      let title : String = "title" <~~ json ?? "N/A",
      let id : NSNumber = "id" <~~ json,
      let backdrop : String = "backdrop_path" <~~ json
      else { return nil }
    
    self.poster = poster
    self.overview = overview
    self.releaseDate = releaseDate
    self.title = title
    self.id = id
    self.backdrop = backdrop
  }
}

public struct PeopleData: Decodable {
  
  public let profile : String
  public let id : NSNumber
  public let knownFor : [knownForArray]?
  public let name : String
  
  public init? (json: JSON) {
    
    guard let profile : String = "profile_path" <~~ json ?? "N/A",
      let id : NSNumber = "id" <~~ json,
      let name : String = "name" <~~ json
      else { return nil }
    
    self.profile = profile
    self.id = id
    self.knownFor = "known_for" <~~ json
    self.name = name
  }
  
  //urlExtension for People: "popular"
  static func updateAllData(urlExtension: String, completionHandler:@escaping (_ details: [PeopleData]?) -> Void){
    
    let nm = NetworkManager.sharedManager
    
    nm.getJSONData(type:"person", urlExtension: urlExtension, completion: {
      data in
      
      if let jsonDictionary = nm.parseJSONData(data)
      {
        guard let peopleResults = ResultsPeopleData(json: jsonDictionary)
          
          else {
            print("Error initializing object")
            return
        }
        
   //     print(jsonDictionary)
        
        guard let peopleData = peopleResults.results
          else {
            print("No such item")
            return
        }
        
        completionHandler(peopleData)
      }
    })
  }
}

