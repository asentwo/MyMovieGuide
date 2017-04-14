//
//  iTunesDataModel.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 4/3/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import Gloss
import CDAlertView



public struct ItunesSearchResultsDataModel: Decodable {
  
  public let results: [ItunesData]?
  
  public init?(json: JSON) {
    
    self.results = "results" <~~ json
  }
}


public struct ItunesData: Decodable {
  
  public let name : String?
  public let kindOfMedia: String?
  public let artwork: URL?
  public let collectionName : String?
  public let buyPriceHD: Double?
  public let rentPriceHD: Double?
  public let collectionPriceHD: Double?
  public let collectionPriceNonHD: Double?
  public let trackPriceNonHD: Double?
  public let itunesLink: URL?
  public let countryType: String?

  public init?(json: JSON) {

    self.name = "trackName" <~~ json
    self.kindOfMedia = "kind" <~~ json
    self.artwork = "artworkUrl100" <~~ json
    self.collectionName = "collectionName" <~~ json
    self.buyPriceHD = "trackHdPrice" <~~ json
    self.rentPriceHD = "trackHdRentalPrice" <~~ json
    self.collectionPriceHD = "collectionHdPrice" <~~ json
    self.collectionPriceNonHD = "collectionPrice" <~~ json
    self.trackPriceNonHD = "trackPrice" <~~ json
    self.itunesLink = "trackViewUrl" <~~ json
    self.countryType = "country" <~~ json
  }
  
  static func updateItunesData(searchTerm: String,completionHandler:@escaping (_ details: [ItunesData]?) -> Void){
    
    let nm = NetworkManager.sharedManager
    
    nm.connectToItunes(searchTerm: searchTerm, completion: {
    
      data in
      
      if let jsonDictionary = nm.parseJSONData(data)
      {
        
     //   print(jsonDictionary)
        
        guard let itunesResults = ItunesSearchResultsDataModel(json: jsonDictionary)
          
          else {
            print("Error initializing object")
             CDAlertView(title: "Sorry", message: "There was an error retrieving data!", type: .error).show()
            return
        }
        
     //   print(itunesResults)
        
        guard let itunesData = itunesResults.results
          else {
            print("No such item")
             CDAlertView(title: "Sorry", message: "There was an error retrieving data!", type: .error).show()
            return
        }
        //  print(itunesData)
        
        completionHandler(itunesData)
      }
    })
  }
}
