//
//  MoviesPopularViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/31/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit


class MoviesInTheatresViewController: UICollectionViewController {
  
  @IBOutlet var inTheatresCollectionView: UICollectionView!
  
  let networkManager = NetworkManager.sharedManager
  
  var movieDataArray: [MovieData] = []
  var moviePosterArray: [UIImage] = {}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    MovieData.updateAllData(urlExtension: "now_playing", completionHandler: {results in
      
      guard let results = results else {
        print("There was an error retrieving genre data info")
        return
      }
      
      self.movieDataArray = results
      
      for movie in movieDataArray {
        
        if let moviePoster = movie.poster {
          self.networkManager.downloadImage(imageExtension: "\(moviePoster)", {(imageData) in
            if let image = UIImage(data: imageData as Data){
              self.moviePosterArray.append(image)
            }
          })
        }
      }
    })
  }
}



//MARK: CollectionView Delegate/ DataSource
extension MoviesInTheatresViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
}



