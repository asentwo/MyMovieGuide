//
//  ItunesCollectionViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 4/4/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit
import CDAlertView

//protocol handleItunesData {
//  func itunesTapped(currentMovieTitle: String, segueType: segueController)
//}

class ItunesCollectionViewController: MasterCollectionViewController {
  
  @IBOutlet var itunesCollectionView: UICollectionView!
  
  let networkManager = NetworkManager.sharedManager
  
  var itunesSearchTerm: String?
  var searchResults: [ItunesData] = []
  var filteredSearchResults: [ItunesData] = []
  
  let itunesReuseIdentifier = "itunesCollectionViewCell"
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startLoadingScreen()
    
    if let searchTerm = itunesSearchTerm {
      
      ItunesData.updateItunesData(searchTerm: searchTerm,completionHandler:{ results in
        
        guard let results = results else {
          CDAlertView(title: "Sorry", message: "There was an error retrieving data!", type: .error).show()
          return
        }
        
        
        self.searchResults = results
        
        for item in self.searchResults {
          
          if (item.artwork != nil) && item.buyPriceHD != nil {
            self.filteredSearchResults.append(item)
          }
        }
        
        
        DispatchQueue.main.async {
          self.hideLoadingScreen()
          self.itunesCollectionView.reloadData()
        }
      })
    }
  }
}


//CollectionView Datasource
extension ItunesCollectionViewController {
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filteredSearchResults.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itunesReuseIdentifier, for: indexPath) as! ItunesCollectionViewCell
    
    
    if let artwork = filteredSearchResults[indexPath.row].artwork {
      cell.itunesImage.sd_setImage(with:artwork)
    }
    
    if let itemName = filteredSearchResults[indexPath.row].name{
      cell.ItemType.text = itemName
    }
    
    if let price = filteredSearchResults[indexPath.row].buyPriceHD{
      cell.price.text = String(describing: price)
    }
    
    if let mediaType = filteredSearchResults[indexPath.row].kindOfMedia {
      cell.mediaType.text = mediaType
    }
    
    return cell
  }
}
