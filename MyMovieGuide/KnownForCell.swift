//
//  KnownForCell.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 3/3/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit


protocol handleKnownForImage {
  func knownForImageTapped(movieID: NSNumber, segue: PeopleSegue)
}

class KnownForCell : UITableViewCell {
  
  var knownForArray: [UIImage] = []
  var knownForExtendedArray: [CastExtendedData] = []
  
  let knownForReuseIdentifier = "knownForCollectCell"
  let segueIdentifier = "peopleToMovieDetailSegue"
  
  let networkManager = NetworkManager.sharedManager
  
  var imageDelegete: handleKnownForImage?
  var movieID: NSNumber?
  
  @IBOutlet weak var knownForCollectionView: UICollectionView!
  
  override func awakeFromNib() {
    knownForCollectionView.delegate = self
    knownForCollectionView.dataSource = self
  }
}


extension KnownForCell:  UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return knownForArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = knownForCollectionView.dequeueReusableCell(withReuseIdentifier: knownForReuseIdentifier, for: indexPath) as! KnownForCollectionViewCell
    
      if let knownPoster = self.knownForExtendedArray[indexPath.row].poster{
        DispatchQueue.main.async {
        cell.knownForImages.sd_setImage(with: URL(string: "\(baseImageURL)\(knownPoster)"))
      }
    }
    return cell
  }
}

extension KnownForCell: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    self.movieID = knownForExtendedArray[indexPath.row].id
      
    guard let movieID = movieID else {return}
    imageDelegete?.knownForImageTapped(movieID: movieID, segue: PeopleSegue.knownFor)
  }
}

