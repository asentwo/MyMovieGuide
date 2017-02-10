//
//  MoviesNewViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/30/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit



class MoviesUpcomingViewController: UICollectionViewController {
  
  //MARK: Constants/ IBOutlets
  @IBOutlet var upcomingCollectionView: UICollectionView!
  
  let networkManager = NetworkManager.sharedManager
  
  var upcomingDataArray: [MovieData] = []
  var upcomingImageArray: [UIImage] = []
  
  let reuseIdentifier = "upcomingCollectionViewCell"
  
  //Layout
  let itemsPerRow: CGFloat = 2
  let sectionInsets = UIEdgeInsets(top: 35.0, left: 10.0, bottom: 35.0, right: 10.0)
  
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    MovieData.updateAllData(urlExtension: "upcoming", completionHandler: { results in
      
      guard let results = results else {
        print("There was an error retrieving upcoming movie data")
        return
      }
      self.upcomingDataArray = results
      
      for movie in self.upcomingDataArray {
        
        if movie.poster != nil {
          
          if let posterImage = movie.poster {
            
            self.networkManager.downloadImage(imageExtension: "\(posterImage)", {
              (imageData) in
              if let image = UIImage(data: imageData as Data){
                self.upcomingImageArray.append(image)
                
                DispatchQueue.main.async {
                  self.upcomingCollectionView.reloadData()
                }
              }
            })
          }
        } else {
          print("poster does not exist: \(movie.title)")
          continue
        }
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
    let cell = upcomingCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UpcomingCollectionViewCell
    cell.posterImage.image = upcomingImageArray[indexPath.row]
    return cell
  }
  
  //  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  //
  //  }
}


//MARK: CollectionViewLayout
extension MoviesUpcomingViewController: UICollectionViewDelegateFlowLayout {
  
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





