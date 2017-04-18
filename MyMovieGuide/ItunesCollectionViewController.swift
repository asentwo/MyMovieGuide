//
//  ItunesCollectionViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 4/4/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit
import CDAlertView
import ParticlesLoadingView

//protocol handleItunesData {
//  func itunesTapped(currentMovieTitle: String, segueType: segueController)
//}

class ItunesCollectionViewController: UICollectionViewController {
  
  @IBOutlet var itunesCollectionView: UICollectionView!
  
  let networkManager = NetworkManager.sharedManager
  
  var itunesSearchTerm: String?
  var searchResults: [ItunesData] = []
  var filteredSearchResults: [ItunesData] = []
  
  let itunesReuseIdentifier = "itunesCollectionViewCell"
  
  //Layout
  let itemsPerRow: CGFloat = 3
  let sectionInsets = UIEdgeInsets(top: 15.0, left: 10.0, bottom: 15.0, right: 10.0)
  
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

  //Particle loading screen
  lazy var loadingView: ParticlesLoadingView = {
    let x = self.view.frame.size.width/2
    let y = self.view.frame.size.height/2
    let view = ParticlesLoadingView(frame: CGRect(x: x - 50, y: y - 100, width: 100, height: 100))
    view.particleEffect = .laser
    view.duration = 1.5
    view.particlesSize = 15.0
    view.clockwiseRotation = true
    view.layer.borderColor = UIColor.lightGray.cgColor
    view.layer.borderWidth = 1.0
    view.layer.cornerRadius = 15.0
    return view
  }()
  
  let label = UILabel(frame: CGRect(x: 0 + 20, y: 0, width: 200, height: 21))
  let w = UIScreen.main.bounds.width
  let h = UIScreen.main.bounds.height
  
  func startLoadingScreen () {
    view.center = CGPoint(x: w / 2, y: h / 2)
    label.center = CGPoint(x: w / 2, y: h / 2 - 50)
    label.textAlignment = .center
    label.text = "Loading"
    label.font = UIFont(name: "Avenir Next Medium", size: 17)
    label.textColor = UIColor.white
    self.view.addSubview(label)
    view.addSubview(loadingView)
    loadingView.startAnimating()
  }
  
  func hideLoadingScreen() {
    self.label.isHidden = true
    self.loadingView.isHidden = true
    self.loadingView.stopAnimating()
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

extension ItunesCollectionViewController: UICollectionViewDelegateFlowLayout  {
  

  
  //Height and width of cells
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let paddingSpaceWidth = sectionInsets.left * (itemsPerRow + 1)
    let paddingSpaceHeight = sectionInsets.top * (itemsPerRow + 2)
    let availableWidth = view.frame.width - paddingSpaceWidth
    let availableHeight = view.frame.height - paddingSpaceHeight
    let widthPerItem = availableWidth / itemsPerRow
    let heightPerItem = availableHeight / itemsPerRow
    
    return CGSize(width: widthPerItem + 50, height: heightPerItem + 50 )
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
