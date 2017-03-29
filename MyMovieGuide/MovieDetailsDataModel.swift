//
//  MovieDetailsDataModel.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/13/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import Gloss
import CDAlertView


//MARK: Release (Ratings)
public struct ReleaseResults : Decodable {
  
  public let releaseResults: [ReleaseData]
  
  public init? (json: JSON){
    
    guard let releaseResults: [ReleaseData] = "countries"  <~~ json
      else {return nil}
    
    self.releaseResults = releaseResults
  }
}

public struct ReleaseData : Decodable {
  
  public let certification : String?
  public let countryCode : String?
  
  public init? (json: JSON) {
    
    self.certification = "certification" <~~ json
    self.countryCode = "iso_3166_1" <~~ json
  }
}



//MARK: Video Data
public struct VideoResults : Decodable {
  
  public let videoResults: [VideoData]
  
  public init? (json: JSON){
    
    guard let videoResults: [VideoData] = "results"  <~~ json
      else {return nil}
    
    self.videoResults = videoResults
  }
}


public struct VideoData : Decodable {
  
  public let key : String
  public let id : String
  public let name : String
  public let site : String
  
  public init? (json: JSON) {
    
    guard let key : String = "key" <~~ json,
      let id : String = "id" <~~ json,
      let name : String = "name" <~~ json,
      let site : String = "site" <~~ json
      else {return nil}
    
    self.key = key
    self.id = id
    self.name = name
    self.site = site
  }
}


//MARK: Image Data
public struct ImageResults : Decodable {
  
  public let posterImages : [PosterData]
  public let backdropImages : [BackdropData]
  
  public init? (json: JSON) {
    
    guard let posterImages : [PosterData] = "posters" <~~ json,
      let backdropImages : [BackdropData] = "backdrops" <~~ json
      else {return nil}
    
    self.posterImages = posterImages
    self.backdropImages = backdropImages
  }
}


public struct PosterData : Decodable {
  
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


public struct BackdropData : Decodable {
  
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



//MARK: General Data
public struct MovieDetailsData: Decodable {
  
  public let backdrop : String?
  public let budget : NSNumber?
  public let homepage : String?
  public let id : NSNumber?
  public let overview: String?
  public let poster : String?
  public let releaseData : String?
  public let revenue : NSNumber?
  public let runtime : NSNumber?
  public let status : String?
  public let tagline : String?
  public let videoAvailable : Bool
  public let averageRating : NSNumber?
  public let title : String?
  public let userRatings : NSNumber?
  public let genre : [GenreData]?
  public let videos : VideoResults?
  public let images : ImageResults?
  public let rating : ReleaseResults?
  
  public init? (json: JSON) {
    
    guard let videoAvailable : Bool = "video" <~~ json
      else {return nil}
    
    self.backdrop = "backdrop_path" <~~ json
    self.budget = "budget" <~~ json
    self.homepage = "homepage" <~~ json
    self.id = "id" <~~ json
    self.overview = "overview" <~~ json
    self.poster = "poster_path" <~~ json
    self.releaseData = "release_date" <~~ json
    self.revenue = "revenue"  <~~ json
    self.runtime = "runtime" <~~ json
    self.status = "status" <~~ json
    self.tagline = "tagline" <~~ json
    self.averageRating = "vote_average" <~~ json
    self.videoAvailable = videoAvailable
    self.title = "title" <~~ json
    self.userRatings = "vote_average" <~~ json
    self.genre = "genres" <~~ json
    self.videos = "videos" <~~ json
    self.images = "images" <~~ json
    self.rating = "releases" <~~ json
  }
  
  
  //MARK: Update Data Function
  
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
            CDAlertView(title: "Sorry", message: "There was an error retrieving data!", type: .error).show()
            return
        }
        
        //  print(jsonDictionary)
        
        completionHandler(movieDetails)
      }
    })
  }
}
