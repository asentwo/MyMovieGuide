//
//  ImagesPeopleCell.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/21/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit


class ImagesPeopleCell : UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
  
  var extraPhotosArray: [UIImage] = []
  var profileImagesArray: [ImageData] = []
  
  let extraPeopleImageReuseIdentifier = "imagesCollectCell"
  
  @IBOutlet weak var extraPeopleImagesCollectionView: UICollectionView!
  
  override func awakeFromNib() {
    extraPeopleImagesCollectionView.delegate = self
    extraPeopleImagesCollectionView.dataSource = self
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return extraPhotosArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = extraPeopleImagesCollectionView.dequeueReusableCell(withReuseIdentifier: extraPeopleImageReuseIdentifier, for: indexPath) as! PeopleImagesCollectionViewCell
    
    DispatchQueue.main.async {
      cell.extraImages.sd_setImage(with: URL(string: "\(baseImageURL)\(self.profileImagesArray[indexPath.row].filePath)"))
      
    }
    return cell
  }
}
