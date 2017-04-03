//
//  iTunesDataModel.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 4/3/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import Gloss


public struct ItunesSearchResultsDataModel: Decodable {
  
  public let results: [ItunesData]?
  
  public init?(json: JSON) {
    
    results = "results" <~~ json
  }
}
public struct ItunesData: Decodable {
  
  public let name : String
  public let artwork: URL?
  public let buyPriceHD: Double
  public let rentPriceHD: Double?
  public init?(json: JSON) {
    
    guard let name: String = "trackName" <~~ json,
      let buyPriceHD: Double = "trackHdPrice" <~~ json
    else {return nil}
    
    self.name = name
    self.buyPriceHD = buyPriceHD
    self.artwork = "artworkUrl100" <~~ json
    self.rentPriceHD = "trackHdRentalPrice" <~~ json
  }
  
  static func updateItunesData(searchTerm: String,completionHandler:@escaping (_ details: [ItunesData]?) -> Void){
    
    let nm = NetworkManager.sharedManager
    
    nm.connectToItunes(searchTerm: searchTerm, completion: {
    
      data in
      
      if let jsonDictionary = nm.parseJSONData(data)
      {
        guard let itunesResults = ItunesSearchResultsDataModel(json: jsonDictionary)
          
          else {
            print("Error initializing object")
            return
        }
        
        guard let itunesData = itunesResults.results
          else {
            print("No such item")
            return
        }
          print(itunesData)
        
        completionHandler(itunesData)
      }
    })
  }
}
