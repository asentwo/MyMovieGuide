//
//  MoviesNewViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/30/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit
import CDAlertView

class UpcomingMoviesViewController: MasterCollectionViewController {
  
  //MARK: Properties
  @IBOutlet var upcomingCollectionView: UICollectionView!
  
  let networkManager = NetworkManager.sharedManager
  
  var upcomingDataArray: [MovieData] = []
  var upcomingImageArray: [String?] = []
  var movieID: NSNumber!
  
  let reuseIdentifier = "upcomingCollectionViewCell"
  let segueIdentifier = "upcomingToDetailSegue"

  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startLoadingScreen()
    MovieData.updateAllData(type: "movie", urlExtension: "upcoming", completionHandler: { results in
      
      guard let results = results else {
        CDAlertView(title: "Sorry", message: "There was an error retrieving data!", type: .notification).show()
        return
      }
      self.upcomingDataArray = results
      
      for movie in self.upcomingDataArray {
        
        if movie.poster != nil {
          
          if let posterImage = movie.poster {
            self.upcomingImageArray.append(posterImage)
          }
        } else {
          print("poster does not exist: \(movie.title)")
          continue
        }
      }
      DispatchQueue.main.async {
        self.hideLoadingScreen()
        self.upcomingCollectionView.reloadData()
      }
    })
  }
}


// MARK: - UICollectionViewDataSource
extension UpcomingMoviesViewController {
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return upcomingImageArray.count
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = upcomingCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UpcomingCollectionViewCell
    
    DispatchQueue.main.async {
      if let upcomingImage = self.upcomingImageArray[indexPath.row] {
        cell.posterImage.sd_setImage(with: URL(string:"\(baseImageURL)\(upcomingImage)"))
      }
    }
   
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension UpcomingMoviesViewController {
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    self.movieID = upcomingDataArray[indexPath.row].id
    performSegue(withIdentifier: segueIdentifier, sender: self)
  }
}

//MARK: Segue
extension UpcomingMoviesViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let upcomingVC = segue.destination as! MoviesDetailViewController
    upcomingVC.iD = self.movieID
    
    //print(self.movieID)
  }
}



