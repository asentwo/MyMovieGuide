//
//  MoviesNewViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/30/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit



class MoviesUpcomingViewController: UICollectionViewController {
  
  @IBOutlet var upcomingCollectionView: UICollectionView!
  
  let networkManager = NetworkManager.sharedManager
  
  var upcomingDataArray: [MovieData] = []
  var upcomingImageArray: [UIImage] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    MovieData.updateAllData(urlExtension: "upcoming", completionHandler: { results in
      
      guard let results = results else {
        print("There was an error retrieving upcoming movie data")
        return
      }
      self.upcomingDataArray = results
      
      for movie in upcomingDataArray {
        
        if let moviePoster = movie.poster {
          self.networkManager.downloadImage(imageExtension: "\(moviePoster)", {
            (imageData) in
            if let image = UIImage(data: imageData as Data){
              self.upcomingImageArray.append(image)
            }
          })
        }
      }
    })
  }
}


//MARK: CollectionView Delegate/ DataSource
extension MoviesUpcomingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return upcomingImageArray.count
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    <#code#>
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    <#code#>
  }
}



