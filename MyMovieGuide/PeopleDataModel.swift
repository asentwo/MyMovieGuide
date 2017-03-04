//
//  ActorsModel.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/29/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import Gloss



//public struct knownForArray : Decodable {
//  
//  public let poster : String?
//  public let overview : String?
//  public let releaseDate : String?
//  public let title : String?
//  public let id : NSNumber?
//  public let backdrop : String?
//  
//  public init?(json: JSON) {
//    
//    self.poster  = "poster_path" <~~ json
//    self.overview  = "overview" <~~ json
//    self.releaseDate = "release_date" <~~ json
//    self.title = "title" <~~ json
//    self.id = "id" <~~ json
//    self.backdrop = "backdrop_path" <~~ json
//  }
//}

//MARK: Image Data
public struct PeopleImageResults : Decodable {
  
  public let images : [ImageData]
  
  public init? (json: JSON) {
    
    guard let images : [ImageData] = "profiles" <~~ json
      
      else {return nil}
    
    self.images = images
    
  }
}

public struct ImageData : Decodable {
  
  public let filePath : String
  public let aspectRatio : NSNumber
  public let height : NSNumber
  public let width : NSNumber
  
  public init?(json: JSON) {
    
    guard let filePath : String = "file_path"  <~~ json,
      let aspectRatio : NSNumber = "aspect_ratio" <~~ json,
      let height : NSNumber = "height" <~~ json,
      let width : NSNumber = "width" <~~ json
      else {return nil}
    
    self.filePath = filePath
    self.aspectRatio = aspectRatio
    self.height = height
    self.width = width
  }
  
}


public struct PeopleData: Decodable {
  
  public let profile : String?
  public let id : NSNumber?
 // public let knownFor : [knownForArray]?
  public let name : String?
  public let birthPlace : String?
  public let birthDay : String?
  public let bio : String?
  public let images : PeopleImageResults?
  
  public init? (json: JSON) {
    
    self.profile = "profile_path" <~~ json
    self.id = "id" <~~ json
   // self.knownFor = "known_for" <~~ json
    self.name = "name" <~~ json
    self.birthPlace = "place_of_birth" <~~ json
    self.birthDay = "birthday" <~~ json
    self.bio = "biography"  <~~ json
    self.images = "images" <~~ json
  }
  
  //urlExtension for People: "popular"
  static func updateAllData(urlExtension: String, completionHandler:@escaping (_ details: PeopleData?) -> Void){
    
    let nm = NetworkManager.sharedManager
    
    nm.getJSONData(type:"person", urlExtension: urlExtension, completion: {
      data in
      
      if let jsonDictionary = nm.parseJSONData(data)
      {
        guard let peopleResults = PeopleData(json: jsonDictionary)
          
          else {
            print("Error initializing object")
            return
        }
        completionHandler(peopleResults)
      }
    })
  }
}

