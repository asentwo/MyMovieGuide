//
//  MoviesPopularViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/31/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit
import SDWebImage
import CDAlertView


class InTheatresMoviesViewController: MasterCollectionViewController {
  
  //MARK: Properties
  @IBOutlet var inTheatresCollectionView: UICollectionView!
  
  let networkManager = NetworkManager.sharedManager
  var inTheatresDataArray: [MovieData] = []
  var inTheatresPosterArray: [String?] = []
  var movieID: NSNumber!
  let reuseIdentifier = "inTheatresCollectionViewCell"
  let segueIdentifier = "inTheatresToDetailSegue"
  
  
  
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.tintColor = UIColor.white
    
    startLoadingScreen()
    MovieData.updateAllData(type:"movie", urlExtension: "now_playing", completionHandler: {results in
      
      guard let results = results else {
        CDAlertView(title: "Sorry", message: "There was an error retrieving data!", type: .error).show()
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
        self.hideLoadingScreen()
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
    
    DispatchQueue.main.async {
      if let inTheaters = self.inTheatresPosterArray[indexPath.row] {
        cell.posterImage.sd_setImage(with: URL(string:"\(baseImageURL)\(inTheaters)"))
      }
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


//MARK: Segue
extension InTheatresMoviesViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let inTheatresVC = segue.destination as! MoviesDetailViewController
    inTheatresVC.iD = self.movieID
  }
}

