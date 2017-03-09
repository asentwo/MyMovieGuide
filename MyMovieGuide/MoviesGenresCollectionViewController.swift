//
//  MoviesGenresDetailViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/7/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit



class MoviesGenresCollectionViewController: UICollectionViewController {
  
  
  //MARK: Properties
  @IBOutlet var genreCollectionView: UICollectionView!
  
  let networkManager = NetworkManager.sharedManager
  
  var genreDataArray: [MovieData] = []
  var genrePosterArray: [UIImage] = []
  var genreID: NSNumber?
  var movieID: NSNumber?
  
  let reuseIdentifier = "genreCollectionViewCell"
  let segueIdentifier = "genreToDetailSegue"
  
  //Layout
  let itemsPerRow: CGFloat = 3
  let sectionInsets = UIEdgeInsets(top: 35.0, left: 10.0, bottom: 35.0, right: 10.0)
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let id = genreID {
      
      MovieData.updateAllData(type:"genre", urlExtension: "\(id)/movies", completionHandler: {results in
        
        guard let results = results else {
          print("There was an error retrieving in theatres movie data")
          return
        }
        self.genreDataArray = results
//        
//        for movie in self.genreDataArray {
//          if movie.poster != nil {
//            if let posterImage = movie.poster {
//              self.updateImage(poster: posterImage)
//            } else if movie.backdrop != nil {
//              if let backdropImage = movie.backdrop {
//                self.updateImage(poster: backdropImage)
//              }
//            }
//          } else {
//            print("poster does not exist: \(movie.title)")
//            continue
//          }
//        }
      })
    }
  }
  
  
//  func updateImage(poster: String) {
//    
//    self.networkManager.downloadImage(imageExtension: "\(poster)", {
//      (imageData) in
//      if let image = UIImage(data: imageData as Data){
//        self.genrePosterArray.append(image)
//        
//        DispatchQueue.main.async {
//          self.genreCollectionView.reloadData()
//        }
//      }
//    })
//  }
}




//MARK: CollectionView Datasource
extension MoviesGenresCollectionViewController {
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return genrePosterArray.count
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! genreCollectionViewCell
    
    if let genrePoster = genreDataArray[indexPath.row].poster {
    cell.genreImageView.sd_setImage(with: URL(string: genrePoster))
      
  //    genrePosterArray[indexPath.row]
    }
    return cell
  }
  
}


//MARK: CollectionView Delegate

extension MoviesGenresCollectionViewController {
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.movieID = genreDataArray[indexPath.row].id
    performSegue(withIdentifier: segueIdentifier, sender: self)
  }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesGenresCollectionViewController: UICollectionViewDelegateFlowLayout {
  
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

extension MoviesGenresCollectionViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! MoviesMasterDetailViewController
      
      destinationVC.iD = self.movieID
 
  }
 
}
