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
    
    //Must register CollectionView Cells
    upcomingCollectionView.register(UpcomingCollectionViewCell.self, forCellWithReuseIdentifier: "upcomingCollectionViewCell")

    
    MovieData.updateAllData(urlExtension: "upcoming", completionHandler: { results in
      
      guard let results = results else {
        print("There was an error retrieving upcoming movie data")
        return
      }
      self.upcomingDataArray = results
      
      for movie in self.upcomingDataArray {
        
          self.networkManager.downloadImage(imageExtension: "\(movie.poster)", {
            (imageData) in
            if let image = UIImage(data: imageData as Data){
              self.upcomingImageArray.append(image)
              
              DispatchQueue.main.async {
                self.upcomingCollectionView.reloadData()
              }
            }
          })
      }
    })
  }
}


//MARK: CollectionView Delegate/ DataSource
extension MoviesUpcomingViewController {

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return upcomingImageArray.count
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = upcomingCollectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCollectionViewCell", for: indexPath)
    cell.backgroundColor = UIColor.blue
    return cell
  }
  
//  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    
//  }
}



