//
//  Networking Manager.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/25/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation


class NetworkManager {
  
static let sharedManager = NetworkManager()
  

private let apiKey = "edd0a1862823ffe4afff6c230daf2c92"
private let readAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZGQwYTE4NjI4MjNmZmU0YWZmZjZjMjMwZGFmMmM5MiIsInN1YiI6IjU4ODhlN2YzOTI1MTQxMTk1YTAwYjgxYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.9wkhVTvuTslhD5LHAUdRmUR-BQw7qb3I_hwfXZOUcvI"
private let baseURL = "https://api.themoviedb.org/3/movie/"

  
  lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
  lazy var session: URLSession = URLSession(configuration: self.configuration)
  
  typealias JSONData = ((Data) -> Void)
  
  
  
  func getJSONData(urlExtension: String, completion: @escaping JSONData) {
    
    let request = URLRequest(url: URL(string:"\(baseURL)\(urlExtension)?api_key=\(apiKey)")! )
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
      
      if error == nil {
        if let httpResponse = response as? HTTPURLResponse {
          switch (httpResponse.statusCode) {
          case 200:
            if let data = data {
              completion(data)
            }
          default:
            print(httpResponse.statusCode)
          }
        }
      } else {
        print("Error: \(error?.localizedDescription)")
      }
      
    })
    
    
    dataTask.resume()
    
  }
  
  
  func parseJSONFromData(_ jsonData: Data?) -> [String : AnyObject]?
  {
    if let data = jsonData {
      
      do {
        let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]//Parses data into a dictionary
        return jsonDictionary
        
      } catch let error as NSError {
        print("error processing json data: \(error.localizedDescription)")
      }
    }
    
    return nil
  }

}
