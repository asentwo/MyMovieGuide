//
//  MoviesNewViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/30/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit

class UpcomingMoviesViewController: UICollectionViewController {
  
  //MARK: Properties
  @IBOutlet var upcomingCollectionView: UICollectionView!
  
  let networkManager = NetworkManager.sharedManager
  
  var upcomingDataArray: [MovieData] = []
  var upcomingImageArray: [String?] = []
  var movieID: NSNumber!
  
  let reuseIdentifier = "upcomingCollectionViewCell"
  let segueIdentifier = "upcomingToDetailSegue"
  
  //Layout
  let itemsPerRow: CGFloat = 2
  let sectionInsets = UIEdgeInsets(top: 35.0, left: 10.0, bottom: 35.0, right: 10.0)
  
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    MovieData.updateAllData(type: "movie", urlExtension: "upcoming", completionHandler: { results in
      
      guard let results = results else {
        print("There was an error retrieving upcoming movie data")
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
    
    if let upcomingImage = upcomingImageArray[indexPath.row] {
      cell.posterImage.sd_setImage(with: URL(string:"\(baseImageURL)\(upcomingImage)"))
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



// MARK: - UICollectionViewDelegateFlowLayout
extension UpcomingMoviesViewController: UICollectionViewDelegateFlowLayout {
  
  //Height and width of cells
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let paddingSpaceWidth = sectionInsets.left * (itemsPerRow + 1)
    let paddingSpaceHeight = sectionInsets.top * (itemsPerRow + 2)
    let availableWidth = view.frame.width - paddingSpaceWidth
    let availableHeight = view.frame.height - paddingSpaceHeight
    let widthPerItem = availableWidth / itemsPerRow
    let heightPerItem = availableHeight / itemsPerRow
    
    return CGSize(width: widthPerItem, height: heightPerItem)
  }
  
  //Returns space in between cells
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  //Returns spacing in between each line
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
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



