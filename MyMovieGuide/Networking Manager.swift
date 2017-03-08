//
//  Networking Manager.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/25/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation

public let baseImageURL = "https://image.tmdb.org/t/p/w500"


class NetworkManager {
  
  static let sharedManager = NetworkManager()
  
  private let apiKey = "edd0a1862823ffe4afff6c230daf2c92"
  private let readAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZGQwYTE4NjI4MjNmZmU0YWZmZjZjMjMwZGFmMmM5MiIsInN1YiI6IjU4ODhlN2YzOTI1MTQxMTk1YTAwYjgxYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.9wkhVTvuTslhD5LHAUdRmUR-BQw7qb3I_hwfXZOUcvI"
  private let baseURL = "https://api.themoviedb.org/3/"
  private let baseVideoURL =  "https://www.youtube.com/watch?v="
  
  
  lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
  lazy var session: URLSession = URLSession(configuration: self.configuration)
  
  
  //Movie Detail: https://api.themoviedb.org/3/movie/14564?api_key=edd0a1862823ffe4afff6c230daf2c92&region=US&append_to_response=videos,images
  //Genre: https://api.themoviedb.org/3/genre/28/movies?api_key=edd0a1862823ffe4afff6c230daf2c92&language=en-US&include_adult=false&sort_by=created_at.asc
  //Now Playing: https://api.themoviedb.org/3/movie/now_playing?api_key=edd0a1862823ffe4afff6c230daf2c92&language=en-US&page=1
  
  
  //Network session creater
  typealias JSONData = ((Data) -> Void)
  
  func getJSONData(type: String, urlExtension: String, completion: @escaping JSONData) {
    
    let request = URLRequest(url: URL(string:"\(baseURL)\(type)/\(urlExtension)?api_key=\(apiKey)&region=US&append_to_response=videos,images")! )
    
    //  print(request)
    
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
  
  
  //JSON Parser
  func parseJSONData(_ jsonData: Data?) -> [String : AnyObject]?
  {
    if let data = jsonData {
      
      do {
        let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]//Parses data into a dictionary
        
     //   print(jsonDictionary)
        
        return jsonDictionary
        
      } catch let error as NSError {
        print("error processing json data: \(error.localizedDescription)")
      }
    }
    return nil
  }
  
  //Image extension https://image.tmdb.org/t/p/w500/
  
  //Image Downloader
  typealias ImageDataHandler = ((Data) -> Void)
  
  func downloadImage(imageExtension: String, _ completion: @escaping ImageDataHandler)  {
    
    let request = URLRequest(url: URL(string: "\(baseImageURL)\(imageExtension)" )!)
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
      
       // print(request)
      
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
  
  
  //Video Downloader
  typealias VideoDataHandler = ((Data) -> Void)
  
  func downloadVideo(videoKey: String, _ completion: @escaping VideoDataHandler)  {
    
    let request = URLRequest(url: URL(string: "\(baseVideoURL)\(videoKey)")!)
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
      
      //  print(request)
      
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
}
