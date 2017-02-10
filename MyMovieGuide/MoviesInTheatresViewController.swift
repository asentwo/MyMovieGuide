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
  var moviePosterArray: [UIImage] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Must register CollectionView Cells
    inTheatresCollectionView.register(InTheatresCollectionViewCell.self, forCellWithReuseIdentifier: "upcomingCollectionViewCell")
    
    MovieData.updateAllData(urlExtension: "now_playing", completionHandler: {results in
      
      guard let results = results else {
        print("There was an error retrieving in theatres movie data")
        return
      }
      
      self.movieDataArray = results
      
      for movie in self.movieDataArray {
          self.networkManager.downloadImage(imageExtension: "\(movie.poster)", {(imageData) in
            if let image = UIImage(data: imageData as Data){
              self.moviePosterArray.append(image)
              print(self.moviePosterArray.count)
              DispatchQueue.main.async {
                self.inTheatresCollectionView.reloadData()
              }
              
            }
          })
      }
    })
  }
}



//MARK: CollectionView Delegate/ DataSource
extension MoviesInTheatresViewController {
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return moviePosterArray.count
    
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = inTheatresCollectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCollectionViewCell", for: indexPath)
    cell.backgroundColor = UIColor.black
  
    return cell
  }
  
//  
//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    
//  }
}



