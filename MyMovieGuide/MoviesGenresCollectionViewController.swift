//
//  MoviesGenresDetailViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/7/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit
import CDAlertView


class MoviesGenresCollectionViewController: MasterViewController {
  
  
  //MARK: Properties
  @IBOutlet weak var searchMoviesBar: UITextField!
  @IBOutlet var genreCollectionView: UICollectionView!
  
  let networkManager = NetworkManager.sharedManager
  
  var genreDataArray: [MovieData] = []
  var genreID: NSNumber?
  var movieID: NSNumber?
  
  let reuseIdentifier = "genreCollectionViewCell"
  let segueIdentifier = "genreToDetailSegue"
  
  //Layout
  let itemsPerRow: CGFloat = 2
  let sectionInsets = UIEdgeInsets(top: 35.0, left: 10.0, bottom: 35.0, right: 10.0)
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startLoadingScreen()
    self.navigationController?.navigationBar.tintColor = UIColor.white
    
    if let id = genreID {
      
      MovieData.updateAllData(type:"genre", urlExtension: "\(id)/movies", completionHandler: {results in
        guard let results = results else {
          CDAlertView(title: "Sorry", message: "There was an error retrieving data!", type: .error).show()
          return
        }
        self.genreDataArray = results
        
        DispatchQueue.main.async {
          self.hideLoadingScreen()
          self.genreCollectionView.reloadData()
        }
      })
    }
  }
  
  @IBAction func searchButtonTapped(_ sender: Any) {
    
    MovieData.updateSearchData(name:(self.searchMoviesBar.text?.replacingOccurrences(of: " ", with: "+").lowercased())!, completionHandler: {results in
      
      guard let results = results else {
        CDAlertView(title: "Sorry", message: "No results found!", type: .error).show()
        return
      }
      self.genreDataArray.removeAll()
      self.genreDataArray = results

      DispatchQueue.main.async {
        self.genreCollectionView.reloadData()
      }
    })
  }
}


//MARK: CollectionView Datasource
extension MoviesGenresCollectionViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return genreDataArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! genreCollectionViewCell
    
      if self.genreDataArray[indexPath.row].poster != nil {
      if let genrePoster = self.genreDataArray[indexPath.row].poster {
            DispatchQueue.main.async {
        cell.genreImageView.sd_setImage(with: URL(string:"\(baseImageURL)\(genrePoster)"), placeholderImage: UIImage(named: "placeholder.png"))
        }
      }
      }else if self.genreDataArray[indexPath.row].backdrop != nil {
        
       if let backdrop = self.genreDataArray[indexPath.row].backdrop {
            DispatchQueue.main.async {
            cell.genreImageView.sd_setImage(with: URL(string:"\(baseImageURL)\(backdrop)"), placeholderImage: UIImage(named: "placeholder.png"))
        }
        }
      } else {
            DispatchQueue.main.async {
        cell.genreImageView.image = #imageLiteral(resourceName: "placeholder")
      }
    }
  
    return cell
  }
}


//MARK: CollectionView Delegate

extension MoviesGenresCollectionViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
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
    
    return CGSize(width: widthPerItem, height: heightPerItem + 40)
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
    let destinationVC = segue.destination as! MoviesDetailViewController
    destinationVC.iD = self.movieID
  }
}


