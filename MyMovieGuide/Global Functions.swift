//
//  Global Functions.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/8/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation

//MARK: Null to Nil
func nullToNil(value : AnyObject?) -> AnyObject? {
  if value is NSNull {
    return nil
  } else {
    return value
  }
}
