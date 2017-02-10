//
//  MoviesPopularViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/31/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit


class MoviesInTheatresViewController: UICollectionViewController {
  
  //MARK: Constants/ IBOutlets
  @IBOutlet var inTheatresCollectionView: UICollectionView!
  
  let networkManager = NetworkManager.sharedManager
  
  var movieDataArray: [MovieData] = []
  var moviePosterArray: [UIImage] = []
  
  let reuseIdentifier = "inTheatresCollectionViewCell"
  
  //Layout
  let itemsPerRow: CGFloat = 2
  let sectionInsets = UIEdgeInsets(top: 35.0, left: 10.0, bottom: 35.0, right: 10.0)
  
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    MovieData.updateAllData(urlExtension: "now_playing", completionHandler: {results in
      
      guard let results = results else {
        print("There was an error retrieving in theatres movie data")
        return
      }
      
      self.movieDataArray = results
    
      
      for movie in self.movieDataArray {
        
        if movie.poster != nil {
          
          if let posterImage = movie.poster {
            
        self.networkManager.downloadImage(imageExtension: "\(posterImage)", {(imageData) in
          
          if let image = UIImage(data: imageData as Data){
            self.moviePosterArray.append(image)
            
            DispatchQueue.main.async {
              self.inTheatresCollectionView.reloadData()
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
extension MoviesInTheatresViewController {
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return moviePosterArray.count
    
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = inTheatresCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InTheatresCollectionViewCell
    cell.posterImage.image = moviePosterArray[indexPath.row]
    
    return cell
  }
  
  //
  //  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  //
  //  }
}


//MARK: CollectionViewLayout
extension MoviesInTheatresViewController: UICollectionViewDelegateFlowLayout {
  
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

