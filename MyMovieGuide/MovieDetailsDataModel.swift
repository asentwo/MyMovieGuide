//
//  MovieDetailsDataModel.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/13/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import Gloss


public struct MovieDetailsData: Decodable {
  
  public let backdrop : String?
  public let budget : String?
  public let homepage : String?
  public let id : String?
  public let overview: String?
  public let poster : String?
  public let releaseData : String?
  public let revenue : String?
  public let runtime : String?
  public let status : String?
  public let tagline : String?
  public let videoAvailable : Bool
  public let averageRating : NSNumber?
  public let title : String?
  
  public init? (json: JSON) {
    
    guard let videoAvailable : Bool = "video" <~~ json
      else {return nil}

    self.backdrop = "backdrop_path" <~~ json
    self.budget = "budget" <~~ json ?? "N/A"
    self.homepage = "homepage" <~~ json
    self.id = "id" <~~ json
    self.overview = "overview" <~~ json
    self.poster = "poster_path" <~~ json
    self.releaseData = "release_date" <~~ json
    self.revenue = "revenue"  <~~ json ?? "N/A"
    self.runtime = "runtime" <~~ json
    self.status = "status" <~~ json
    self.tagline = "tagline" <~~ json
    self.averageRating = "vote_average" <~~ json
    self.videoAvailable = videoAvailable
    self.title = "title" <~~ json
  }
  
   // https://api.themoviedb.org/3/movie/232?api_key=edd0a1862823ffe4afff6c230daf2c92&language=en-US
  
  //urlExtension for MovieDetail: ID number
  static func updateAllData(urlExtension: String, completionHandler:@escaping (_ details: MovieDetailsData?) -> Void){
    
    let nm = NetworkManager.sharedManager
    
    nm.getJSONData(type:"movie", urlExtension: urlExtension, completion: {
      data in
      
      if let jsonDictionary = nm.parseJSONData(data)
      {
        guard let movieDetails = MovieDetailsData(json: jsonDictionary)
          
          else {
            print("Error initializing object")
            return
        }
        
        //  print(jsonDictionary)
        
        completionHandler(movieDetails)
      }
    })
  }
}
