//
//  MoviesInTheatreDetailViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/13/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit


class MoviesInTheatreDetailViewController: UITableViewController {
  
  //MARK: Properties
  
  @IBOutlet var inTheatresTableView: UITableView!
  
  let networkManager = NetworkManager.sharedManager
  
  var movieID: NSNumber?
  
  var movieDetailsData: MovieDetailsData?
  var movieDetailsPoster: UIImage?
  
  let reuseIdentifier = "inTheatresDetailTableViewCell"
  
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  
    if let movieID = self.movieID {
      
      
      MovieDetailsData.updateAllData(urlExtension: "\(movieID)", completionHandler: { results in
        
        guard let results = results else {
          print("There was an error retrieving upcoming movie data")
          return
        }
      
        self.movieDetailsData = results
        
        if self.movieDetailsData?.poster != nil {
          
          if let posterImage = self.movieDetailsData?.poster {
            
            self.updateImage(poster: posterImage)
          } else if self.movieDetailsData?.backdrop != nil {
            
            if let backdropImage = self.movieDetailsData?.backdrop {
              self.updateImage(poster: backdropImage)
            } else {
              print("poster does not exist: \(self.movieDetailsData?.title)")
              self.movieDetailsPoster = #imageLiteral(resourceName: "placeholder")
            }
          }
        }
      })
    }
  }
  
  
  func updateImage(poster: String) {
    
    self.networkManager.downloadImage(imageExtension: "\(poster)", {
      (imageData) in
      if let image = UIImage(data: imageData as Data){
        self.movieDetailsPoster = image
        
        DispatchQueue.main.async {
          self.inTheatresTableView.reloadData()
        }
      }
    })
  }
  
}


//MARK: TableView Datasource
extension MoviesInTheatreDetailViewController {
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = inTheatresTableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! InTheatresDetailTableViewCell
    
    return cell
  }
  
}
