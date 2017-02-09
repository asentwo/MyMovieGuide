//
//  MoviesNewViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/30/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit



class MoviesUpcomingViewController: UICollectionViewController {
  
  //urlExtensions for Movies: "popular", "upcoming", "now_playing"
  //urlExtension for People: "popular"
  //urlExtension for Genres: "list"
//  GenreData.updateAllData(urlExtension:"list", completionHandler: { results in
//  
//  guard let results = results else {
//  
//  print("There was an error retrieving info")
//  
//  return
//  }
//  print(results)
//  })
  
}


//MARK: CollectionView Delegate/ DataSource
extension MoviesUpcomingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    <#code#>
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    <#code#>
  }
}



//extension MoviesUpcomingViewController : UICollectionViewLayout {
//  
//  
//  
//}
