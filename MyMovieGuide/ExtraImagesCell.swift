//
//  ImagesCell.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/17/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit


class ExtraImagesCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
  
  var photosArray: [UIImage] = []
  
  let extraImageReuseIdentifier = "extraImageCollectionViewCell"
  
  @IBOutlet weak var extraImagesCollectionView: UICollectionView!
  
  override func awakeFromNib() {
    extraImagesCollectionView.delegate = self
    extraImagesCollectionView.dataSource = self
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photosArray.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = extraImagesCollectionView.dequeueReusableCell(withReuseIdentifier: extraImageReuseIdentifier, for: indexPath) as! extraImagesCollectionViewCell
    
    cell.extraImages.image = photosArray[indexPath.row]
    
    return cell
  }
 
}