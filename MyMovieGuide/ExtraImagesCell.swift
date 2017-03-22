//
//  ImagesCell.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/17/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

protocol handleExtraImage {
  func extraImageTapped(Image: String, segueType: segueController)
}


class ExtraImagesCell: UITableViewCell {
  
  var photosArray: [String] = []
  var extraImagesArray: [BackdropData]?
  
  let extraImageReuseIdentifier = "extraImageCollectionViewCell"
  
  var imageDelegate: handleExtraImage?
  var currentImage : String?
  
  @IBOutlet weak var extraImagesCollectionView: UICollectionView!
  
  override func awakeFromNib() {
    extraImagesCollectionView.delegate = self
    extraImagesCollectionView.dataSource = self
  }
}



extension ExtraImagesCell : UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photosArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = extraImagesCollectionView.dequeueReusableCell(withReuseIdentifier: extraImageReuseIdentifier, for: indexPath) as! extraImagesCollectionViewCell
    
    if let xtraImage = extraImagesArray {
      
      DispatchQueue.main.async {
        cell.extraImages.sd_setImage(with: URL(string: "\(baseImageURL)\(xtraImage[indexPath.row].filePath)"))
        
      }
    }
    return cell
  }
}



extension ExtraImagesCell : UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.currentImage = photosArray[indexPath.row]
    
    guard let currentImage = currentImage else { return }
    imageDelegate?.extraImageTapped(Image: currentImage, segueType: segueController.image)
    
  }
}
