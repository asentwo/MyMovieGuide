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


public struct PeopleData: Decodable {
  
  
  
  
  
  
  
  
}
