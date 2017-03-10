//
//  CastCell.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/17/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit


protocol handleCastData {
  func imageTapped(ID: NSNumber, segueType: segueController)
}


class CastCell : UITableViewCell {
  
  var castPhotosArray: [CastData] = []
 // var castImagesArray: [String] = []
  
  var imageDelegate: handleCastData?
  var castID: NSNumber?
  
  let extraImageReuseIdentifier = "castCollectCell"
  
  let networkManager = NetworkManager.sharedManager
  
  @IBOutlet weak var castCollectiontView: UICollectionView!
  
  override func awakeFromNib() {
    
    castCollectiontView.delegate = self
    castCollectiontView.dataSource = self
    
  }
  
}

extension CastCell: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return castPhotosArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = castCollectiontView.dequeueReusableCell(withReuseIdentifier: extraImageReuseIdentifier, for: indexPath) as! CastCollectionViewCell
    
    
    cell.actorName.text = self.castPhotosArray[indexPath.row].name
    cell.characterName.text = self.castPhotosArray[indexPath.row].character
    
    if let profilePic = self.castPhotosArray[indexPath.row].profilePic {
      cell.actorProfileImage.sd_setImage(with: URL(string:  "\(baseImageURL)\(profilePic)"), placeholderImage: UIImage(named: "placeholder.png"))
    }
    cell.actorProfileImage.layer.cornerRadius = cell.actorProfileImage.frame.size.height/2
    cell.actorProfileImage.clipsToBounds = true
    cell.actorProfileImage.layer.masksToBounds = true
    cell.actorProfileImage.layer.borderColor = UIColor.white.cgColor
    
    return cell
  }
}



extension CastCell: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.castID = castPhotosArray[indexPath.row].id
    
    guard let castID = castID else { return }
    imageDelegate?.imageTapped(ID: castID, segueType: segueController.cast)
    
  }
}
