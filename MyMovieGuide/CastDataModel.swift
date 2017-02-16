//
//  CastDataModel.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/15/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import Gloss

public struct Cast: Decodable {
  
  public let cast : [CastData]?
  
  public init?(json: JSON) {
    
    cast = "cast" <~~ json
  }
}

public struct CastData : Decodable {
  
  public let id : NSNumber?
  public let character : String?
  public let name : String
  public let profilePic : String?
  
  
  public init?(json: JSON) {
    
    guard let name : String = "name" <~~ json
      else {return nil}
    
    self.id = "id" <~~ json
    self.character = "character" <~~ json
    self.profilePic = "profile_path" <~~ json
    self.name = name
    
  }
  
  //urlExtension for Cast: "credits"
  static func updateAllData(urlExtension: String, completionHandler:@escaping (_ details: [CastData]?) -> Void){
    
    let nm = NetworkManager.sharedManager
    
    nm.getJSONData(type:"credits", urlExtension: urlExtension, completion: {
      data in
      
      if let jsonDictionary = nm.parseJSONData(data)
      {
        guard let cast = Cast(json: jsonDictionary)
          
          else {
            print("Error initializing object")
            return
        }
        
        //  print(jsonDictionary)
        
        guard let castData = cast.cast
          else {
            print("No cast data exists")
            return
        }
        
        completionHandler(castData)
      }
    })
  }
}
