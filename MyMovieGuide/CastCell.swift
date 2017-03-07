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
  var castImagesArray: [UIImage] = []
  
  var imageDelegate: handleCastData?
  var castID: NSNumber?
  
  let extraImageReuseIdentifier = "castCollectCell"
  
  let networkManager = NetworkManager.sharedManager
  
  @IBOutlet weak var castCollectiontView: UICollectionView!
  
  override func awakeFromNib() {
    

    castCollectiontView.delegate = self
    castCollectiontView.dataSource = self
    
    }
//  func updateImage(imageType: imageDownload, ext: String) {
//    
//    self.networkManager.downloadImage(imageExtension: "\(ext)", {
//      (imageData) in
//      if let image = UIImage(data: imageData as Data) {
//        self.castImagesArray.append(image)
//        
//      }
//      DispatchQueue.main.async {
//        self.castCollectiontView.reloadData()
//      }
//
//      
//    })
//  }
//  
//  func addImagesToArray(completion: Void) {
//   
//    for cast in self.castPhotosArray {
//      
//      print(cast.profilePic!)
//      
//      if cast.profilePic != nil {
//        if let castPic = cast.profilePic {
//          
//          self.updateImage(imageType: imageDownload.cast, ext: castPic)
//        }
//      } else {
//        print("actor pic does not exist: \(cast.name)")
//        continue
//      }
//  }
//  
//}
}

  extension CastCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return castImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = castCollectiontView.dequeueReusableCell(withReuseIdentifier: extraImageReuseIdentifier, for: indexPath) as! CastCollectionViewCell
      
     // self.addImagesToArray(completion: {_ in
      
        cell.actorName.text = self.castPhotosArray[indexPath.row].name
        cell.characterName.text = self.castPhotosArray[indexPath.row].character
        cell.actorProfileImage.image = self.castImagesArray[indexPath.row]
        cell.actorProfileImage.layer.cornerRadius = cell.actorProfileImage.frame.size.height/2
        cell.actorProfileImage.clipsToBounds = true
        cell.actorProfileImage.layer.masksToBounds = true
        cell.actorProfileImage.layer.borderColor = UIColor.white.cgColor
      
//      }())
        
     print("castCell image array count:\(self.castImagesArray.count)")
      
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
