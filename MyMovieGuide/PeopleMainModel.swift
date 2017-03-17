//
//  PeopleMainModel.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 3/16/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import Gloss



public struct ResultsPeopleData: Decodable {
  
  public let results: [PeopleMainData]?
  
  public init?(json: JSON) {
    
    results = "results" <~~ json
  }
}


public struct PeopleMainData: Decodable {
  
  public let poster : String?
  public let id: NSNumber?
  public let name: String?
  
  public init? (json: JSON) {
    
    self.poster  = "profile_path" <~~ json
    self.id = "id" <~~ json
    self.name = "name" <~~ json
  }
  
  //urlExtensions: "person"
  static func updateAllData(urlExtension: String,completionHandler:@escaping (_ details: [PeopleMainData]?) -> Void){
    
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
        
        guard let peopleData = peopleResults.results
          else {
            print("No such item")
            return
        }
      //   print(peopleData)
        
        completionHandler(peopleData)
      }
    })
  }

  
}





