//
//  MoviesPopularViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/31/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit
import SDWebImage


class InTheatresMoviesViewController: UICollectionViewController {
  
  //MARK: Properties
  @IBOutlet var inTheatresCollectionView: UICollectionView!
  
  let networkManager = NetworkManager.sharedManager
  
  var inTheatresDataArray: [MovieData] = []
  var inTheatresPosterArray: [String?] = []
  var movieID: NSNumber!
  
  let reuseIdentifier = "inTheatresCollectionViewCell"
  let segueIdentifier = "inTheatresToDetailSegue"
  
  //Layout
  let itemsPerRow: CGFloat = 2
  let sectionInsets = UIEdgeInsets(top: 35.0, left: 10.0, bottom: 35.0, right: 10.0)
  
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    MovieData.updateAllData(type:"movie", urlExtension: "now_playing", completionHandler: {results in
      
      guard let results = results else {
        print("There was an error retrieving in theatres movie data")
        return
      }
      self.inTheatresDataArray = results
      
      for movie in self.inTheatresDataArray {
        if movie.poster != nil {
          self.inTheatresPosterArray.append(movie.poster!)
        } else {
          print("poster does not exist: \(movie.title)")
          continue
        }
      }
      DispatchQueue.main.async {
        self.inTheatresCollectionView.reloadData()
      }
      
    })
  }
}

// MARK: - UICollectionViewDataSource
extension InTheatresMoviesViewController {
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return inTheatresPosterArray.count
    
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = inTheatresCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InTheatresCollectionViewCell
    
    if let inTheaters = inTheatresPosterArray[indexPath.row] {
      cell.posterImage.sd_setImage(with: URL(string:"\(baseImageURL)\(inTheaters)"))
    }
    return cell
  }
  
  
  
}

// MARK: - UICollectionViewDelegate
extension InTheatresMoviesViewController {
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.movieID = inTheatresDataArray[indexPath.row].id
    performSegue(withIdentifier: segueIdentifier, sender: self)
    
  }
}



// MARK: - UICollectionViewDelegateFlowLayout
extension InTheatresMoviesViewController: UICollectionViewDelegateFlowLayout {
  
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
extension InTheatresMoviesViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let inTheatresVC = segue.destination as! MoviesMasterDetailViewController
    inTheatresVC.iD = self.movieID
  }
}

